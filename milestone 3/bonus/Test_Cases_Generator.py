import random
class Res_instruction:
    def __init__(self, name, instr_type):
        self.name = name
        self.type = instr_type

register = [f"x{i}" for i in range(32)]

Inst = [Res_instruction("sb", 'S'), Res_instruction("sh", 'S'), Res_instruction("sw", 'S'),
    Res_instruction("addi", 'I'), Res_instruction("slti", 'I'), Res_instruction("sltiu", 'I'),
    Res_instruction("xori", 'I'), Res_instruction("ori", 'I'), Res_instruction("andi", 'I'),
    Res_instruction("slli", 'I'), Res_instruction("srli", 'I'), Res_instruction("srai", 'I'),
    Res_instruction("add", 'R'), Res_instruction("sub", 'R'), Res_instruction("sll", 'R'),
    Res_instruction("slt", 'R'), Res_instruction("sltu", 'R'), Res_instruction("auipc", 'U'),
    Res_instruction("xor", 'R'), Res_instruction("srl", 'R'), Res_instruction("sra", 'R'),
    Res_instruction("or", 'R'), Res_instruction("and", 'R'), Res_instruction("mul", 'R'),
    Res_instruction("mulh", 'R'), Res_instruction("mulhsu", 'R'), Res_instruction("mulhu", 'R'),
    Res_instruction("div", 'R'), Res_instruction("divu", 'R'), Res_instruction("rem", 'R'),
    Res_instruction("remu", 'R'), Res_instruction("lui", 'U'), Res_instruction("jal", 'J'),
    Res_instruction("jalr", 'I'), Res_instruction("beq", 'B'), Res_instruction("bne", 'B'),
    Res_instruction("blt", 'B'), Res_instruction("bge", 'B'), Res_instruction("bltu", 'B'),
    Res_instruction("bgeu", 'B'), Res_instruction("lb", 'L'), Res_instruction("lh", 'L'),
    Res_instruction("lw", 'L'), Res_instruction("lbu", 'L'), Res_instruction("lhu", 'L'),
    Res_instruction("fence", 'Y'), Res_instruction("ecall", 'Y'), Res_instruction("ebreak", 'Y'),]

def get_instructions(inst_count):
    with open("TestCase.txt", "w") as f:
        for i in range(inst_count):
            ins_res = random.choice(Inst)
            r1, r2, rd = random.randint(0, 31), random.randint(0, 31), random.randint(0, 31)
            imm = random.randint(0, 99)
            branchim = 4 * (random.randint(1, inst_count - i))
            if ins_res.type == 'R':
                Inst_line = f"{ins_res.name} {register[rd]}, {register[r1]}, {register[r2]}"
            elif ins_res.type == 'I':
                Inst_line = f"{ins_res.name} {register[rd]}, {register[r1]}, {imm}"
            elif ins_res.type == 'S':
                Inst_line = f"{ins_res.name} {register[r1]}, {imm}({register[r2]})"
            elif ins_res.type == 'B':
                Inst_line = f"{ins_res.name} {register[r1]}, {register[r2]}, {branchim}"
            elif ins_res.type == 'U':
                Inst_line = f"{ins_res.name} {register[rd]}, {imm}"
            elif ins_res.type == 'J':
                Inst_line = f"{ins_res.name} {register[rd]}, {branchim}"
            elif ins_res.type == 'L':
                Inst_line = f"{ins_res.name} {register[rd]}, {imm}({register[r1]})"
            elif ins_res.type == 'Y':
                Inst_line = f"{ins_res.name}"
            else:
                continue 
            f.write(Inst_line + "\n")

if __name__ == "__main__":
    inst_num = int(input("Hi! how many instructions to generate: "))
    get_instructions(inst_num)
