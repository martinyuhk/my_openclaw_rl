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

#RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
#    --allow-change-held-packages libnccl-dev=2.30.4-1+cuda12.9 libnccl2=2.30.4-1+cuda12.9 \
# && rm -rf /var/lib/apt/lists/*

#RUN /my_workspace/.venv/bin/pip install nvidia-nccl-cu12==2.30.4

RUN cd OpenClaw-RL && git clone -b v1.2.1 https://github.com/deepseek-ai/DeepEP.git && cd DeepEP && /my_workspace/.venv/bin/pip install -e . --no-build-isolation

RUN cd OpenClaw-RL && /my_workspace/.venv/bin/pip install -e slime/slime/backends/megatron_utils/kernels/int4_qat --no-build-isolation

RUN touch /tmp/20260727_2130
