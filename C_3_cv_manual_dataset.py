filename = "abalone.data.libsvm.train.scale"

import random
random.seed(1)

with open(filename) as f:
    data = [line.rstrip() for line in f]
    random.shuffle(data)

lines_per_file = len(data) / 5

for i in range(0, 5):
    with open(filename + f"_{i + 1}", 'w') as f:
        f.write('\n'.join(data[int(lines_per_file * i) : int(lines_per_file * i + lines_per_file)]))
        f.write('\n')
        with open(filename + f"_{i + 1}_rest", 'w') as fr:
            fr.write('\n'.join(data[0 : int(lines_per_file * i)]))
            if i != 0:
                fr.write('\n')
            fr.write('\n'.join(data[int(lines_per_file * i + lines_per_file):]))
            if i != 4:
                fr.write('\n')
