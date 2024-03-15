FROM gcr.io/deeplearning-platform-release/tf-cpu.1-15
COPY cloud-samples-final /train
WORKDIR /train/tensorflow/standard/mnist
CMD ["sh", "-c", "\
  rm -f /tmp/benchmark.log; \
  while true; do \
    START_T=$(date +%s); \
    rm -rf /tmp/mnist; \
    python -m trainer.task \
           --train-file=/train/data/train-images-idx3-ubyte.gz \
           --train-labels-file=/train/data/train-labels-idx1-ubyte.gz \
           --test-file=/train/data/train-images-idx3-ubyte.gz \
           --test-labels-file=/train/data/train-labels-idx1-ubyte.gz \
           --job-dir=/tmp/mnist; \
    END_T=$(date +%s); \
    echo \"benchmark.s: $(( END_T - START_T ))\" >> /tmp/benchmark.log; \
    tail -n 1 /tmp/benchmark.log; \
  done"]
