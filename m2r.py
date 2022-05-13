f = "test.m"

lines = open(f, "r").readlines()
lines = [x.strip().split(" ") for x in lines]
lines = [[l[0]] + [int(x) for x in l[1:]] for l in lines]

addr_m_to_addr_r = {}
lines_r = []

for i in range(len(lines)):
    addr_m_to_addr_r[i] = len(lines_r)
    ins = lines[i]
    if ins[0] == "ADD" or ins[0] == "SUB":
        lines_r.append(["LD", 1, ins[2]])
        lines_r.append(["LD", 2, ins[3]])
        lines_r.append([ins[0], 1, 2, 1])
        lines_r.append(["ST", ins[3], 1])
    elif ins[0] == "COP":
        lines_r.append(["LD", 1, ins[2]])
        lines_r.append(["ST", ins[1], 1])
    elif ins[0] == "JMP":
        lines_r.append([ins[0], ins[1]]) # BAD ADDR
    elif ins[0] == "JMX":
        lines_r.append(["LD", 1, ins[1]])
        lines_r.append([ins[0], 1, ins[2]]) # BAD ADDR
    print(lines[i])


for i in range(len(lines_r)):
    ins = lines_r[i]
    if ins[0] == "JMP":
        if ins[1] not in addr_m_to_addr_r:
            ins[1] = len(lines_r)
        else:
            ins[1] = addr_m_to_addr_r[ins[1]]
    elif ins[0] == "JMX":
        if ins[2] not in addr_m_to_addr_r:
            ins[2] = len(lines_r)
        else:
            ins[2] = addr_m_to_addr_r[ins[2]]


for i in range(len(lines_r)):
    while len(lines_r[i]) < 4:
        lines_r[i].append(0)

print("")
for x in lines_r:
    print(x)

print("")


op2bin= {}
op2bin["ADD"] = 1
op2bin["JMP"] = 7
op2bin["COP"] = 5
op2bin["JMX"] = 8
op2bin["LD"] = 19
op2bin["ST"] = 20

print("(")
for x in lines_r:
    print("(x\"%02x%02x%02x%02x\")," % (op2bin[x[0]], x[1], x[2], x[3]))
print(", others => x\"00000000\")")
