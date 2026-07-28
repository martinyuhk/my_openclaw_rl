FROM nvidia/cuda:12.9.2-cudnn-devel-ubuntu24.04

WORKDIR /my_workspace

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv git \
 && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv .venv

RUN git clone https://github.com/Gen-Verse/OpenClaw-RL

RUN /my_workspace/.venv/bin/pip install \
  torch==2.9.1+cu129 \
  torchvision==0.24.1+cu129 \
  torchaudio==2.9.1+cu129 \
  --index-url https://download.pytorch.org/whl/cu129

RUN cd OpenClaw-RL && /my_workspace/.venv/bin/pip install -r requirements.txt

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
    wget \
 && rm -rf /var/lib/apt/lists/*

#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb && dpkg -i cuda-keyring_1.1-1_all.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
#    python3-dev libibverbs-dev librdmacm-dev ninja-build libnccl2 libnccl-dev \
 python3-dev libibverbs-dev librdmacm-dev ninja-build \
 && rm -rf /var/lib/apt/lists/*

#SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

#RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
#    --allow-change-held-packages libnccl-dev=2.30.4-1+cuda12.9 libnccl2=2.30.4-1+cuda12.9 \
# && rm -rf /var/lib/apt/lists/*

#RUN /my_workspace/.venv/bin/pip install nvidia-nccl-cu12==2.30.4

ENV TORCH_CUDA_ARCH_LIST="8.0"

RUN cd OpenClaw-RL && git clone -b v1.2.1 https://github.com/deepseek-ai/DeepEP.git && cd DeepEP && /my_workspace/.venv/bin/pip install . --no-build-isolation

RUN cd OpenClaw-RL && /my_workspace/.venv/bin/pip install slime/slime/backends/megatron_utils/kernels/int4_qat --no-build-isolation

RUN cd OpenClaw-RL && git clone https://github.com/NVIDIA/apex.git && cd apex && APEX_CPP_EXT=1 APEX_CUDA_EXT=1 /my_workspace/.venv/bin/pip install -v --no-build-isolation .

RUN MAX_JOBS=8 /my_workspace/.venv/bin/pip install --no-build-isolation -v flash-attn==2.7.4.post1

RUN /my_workspace/.venv/bin/pip install "flashinfer-jit-cache==0.6.3" --index-url https://flashinfer.ai/whl/cu129

RUN /my_workspace/.venv/bin/pip install "megatron-bridge @ git+https://github.com/fzyzcjy/Megatron-Bridge.git@35b4ebfc486fb15dcc0273ceea804c3606be948a" --no-build-isolation

RUN /my_workspace/.venv/bin/pip install --no-build-isolation "transformer_engine[pytorch,core_cu12]==2.10.0"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
#    python3-dev libibverbs-dev librdmacm-dev ninja-build libnccl2 libnccl-dev \
 python3-apt \
 && rm -rf /var/lib/apt/lists/*

RUN /my_workspace/.venv/bin/pip install transformers==5.3.0

RUN cd OpenClaw-RL && git clone --recursive https://github.com/NVIDIA-NeMo/Megatron-Bridge.git Megatron-Bridge-qwen35 && cd Megatron-Bridge-qwen35 && git checkout ebca893607d48388a6c083bfc143bc05621cc753 && git submodule update --init --recursive && cd 3rdparty/Megatron-LM && git checkout 17a67b9a97fb11a75933fd7f76ad76e1ac98a53d 

RUN cd OpenClaw-RL/Megatron-Bridge-qwen35 && /my_workspace/.venv/bin/pip uninstall -y megatron-bridge megatron-core mbridge && /my_workspace/.venv/bin/pip install --no-deps ./3rdparty/Megatron-LM && /my_workspace/.venv/bin/pip install --no-deps ./


RUN touch /tmp/20260728_1346
