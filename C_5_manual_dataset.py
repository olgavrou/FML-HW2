filename = "abalone.data.libsvm.train.scale"

with open(filename) as f:
    data = [line.rstrip() for line in f]

extra_lines = 314

for i in range(1, int(len(data) / extra_lines) + 1):
    with open(filename + f"_partition_{i}", 'w') as f:
        f.write('\n'.join(data[0 : extra_lines * i]))
        f.write('\n')