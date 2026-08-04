FROM ghcr.io/martinyuhk/my_openclaw_rl:v1.0.3

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
 libnuma-dev numactl curl wget git-lfs net-tools \
 && rm -rf /var/lib/apt/lists/*

#RUN /my_workspace/.venv/bin/pip install transformers==5.3.0

#RUN cd OpenClaw-RL && git clone --recursive https://github.com/NVIDIA-NeMo/Megatron-Bridge.git Megatron-Bridge-qwen35 && cd Megatron-Bridge-qwen35 && git checkout ebca893607d48388a6c083bfc143bc05621cc753 && git submodule update --init --recursive && cd 3rdparty/Megatron-LM && git checkout 17a67b9a97fb11a75933fd7f76ad76e1ac98a53d 

#RUN cd OpenClaw-RL/Megatron-Bridge-qwen35 && /my_workspace/.venv/bin/pip uninstall -y megatron-bridge megatron-core mbridge && /my_workspace/.venv/bin/pip install --no-deps ./3rdparty/Megatron-LM && /my_workspace/.venv/bin/pip install --no-deps ./


RUN touch /tmp/20260804_1755
