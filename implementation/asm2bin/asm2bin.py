# Using the assembler:
#   - The assembler reads the file "asm.txt" and writes the binary to "bin.txt"
#   1. Put your ASM code in "asm.txt"
#   2. Run the assembler with "python asm2bin.py"
#   3. Copy the binary from "bin.txt" to the memory.txt file

# The assembler supports labels. To implement a label, write it on
# the same line as the line that you want to branch to. All labels must end with a colon and
# have a space after. When branching to a line with a label, you should use the label’s name
# without the colon instead of the destination address.

# Convert the special values to their addresses
def convertSpecialVals(asm):
    modifiedAsm = []
    for inst in asm:
        inst = inst.replace("RA","521")
        inst = inst.replace("SP","523")
        inst = inst.replace("A0","528")
        inst = inst.replace("A1","530")
        inst = inst.replace("A3","532")
        inst = inst.replace("A4","534")
        inst = inst.replace("A5","536")
        inst = inst.replace("A6","538")
        inst = inst.replace("S0","540")
        inst = inst.replace("S1","542")
        inst = inst.replace("S2","544")
        inst = inst.replace("S3","546")
        inst = inst.replace("S4","548")
        inst = inst.replace("S5","550")
        inst = inst.replace("S6","552")
        inst = inst.replace("S7","554")
        inst = inst.replace("T0","556")
        inst = inst.replace("T1","558")
        inst = inst.replace("T2","560")
        inst = inst.replace("T3","562")
        inst = inst.replace("T4","564")
        inst = inst.replace("T5","566")
        inst = inst.replace("T6","568")
        inst = inst.replace("T7","570")
        inst = inst.replace("T8","572")
        inst = inst.replace("T9","574")
        inst = inst.replace("T10","576")
        inst = inst.replace("T11","578")
        inst = inst.replace("T12","580")
        inst = inst.replace("T13","582")
        inst = inst.replace("T14","584")
        inst = inst.replace("T15","586")

        if ":" in inst:
            inst = inst.split(":")[1]
        modifiedAsm.append(inst.strip())
    return modifiedAsm

# Find labels in the asm and store them in a dictionary
def getLabels(asm, labels):
    for i in range(len(asm)):
        if ":" in asm[i]:
            labels[asm[i].split(":")[0]] = i*2

# Get binary of each instruction
def getBinary(inst):
    brokenInst = inst.split(" ")
    if len(brokenInst) > 1 and int(brokenInst[1]) > 4095 or len(brokenInst) == 1 and brokenInst[0] != "SO" and brokenInst[0] != "LI":
        print("Error: Your instruction is invalid. The immediate cannot be larger than 4095")
        quit()
    match brokenInst[0].upper():
        case "LW":
            return iType(brokenInst[1]) + "0000"
        case "SW":
            return iType(brokenInst[1]) + "0001"
        case "LMEM":
            return iType(brokenInst[1]) + "0010"
        case "SMEM":
            return iType(brokenInst[1]) + "0011"
        case "ADD":
            return iType(brokenInst[1]) + "0100"
        case "SUB":
            return iType(brokenInst[1]) + "0101"
        case "ADDI":
            return iType(brokenInst[1]) + "0110"
        case "CMPI":
            return iType(brokenInst[1]) + "0111"
        case "CMP":
            return iType(brokenInst[1]) + "1000"
        case "B":
            return bType(brokenInst[1], brokenInst[2]) + "1001"
        case "BMEM":
            return bMemType(brokenInst[1], brokenInst[2]) + "1010"
        case "LLI":
            return iType(brokenInst[1]) + "1011"
        case "SLLI":
            return iType(brokenInst[1]) + "1100"
        case "LI":
            return "0000000000001110"
        case "SO":
            return "0000000000001111"
        case _:
            return ""

# def to_twos_complement(value, bits):
#     # If value is negative, convert it to its 2's complement representation
#     if value < 0:
#         value = (1 << bits) + value
#     # Format value as a binary string, zero-padded to the specified number of bits
#     format_string = '{:0' + str(bits) + 'b}'
#     return format_string.format(value)

def iType(imm):
    return format(int(imm), '012b')

def bType(cCode, label):
    offset = labels[label]
    return cCode + format(int(offset), '010b')

def bMemType(cCode, addr):
    return cCode + format(int(addr), '010b')

if __name__ == "__main__":
    labels = {}

    # Read and make upper case
    asm = open("asm.txt").read().split("\n")
    asm = [line.upper() for line in asm]

    # Add labels to the dictionary
    getLabels(asm, labels)

    # Convert special values to their addresses
    asm = convertSpecialVals(asm)

    # Get binary of each instruction
    for i in range(len(asm)):
        asm[i] = getBinary(asm[i])

    # Convert binary to hex with 4 bits per line
    for i in range(len(asm)):
        asm[i] = hex(int(asm[i], 2))[2:].zfill(4)
    
    # Write to file
    open("bin.txt", "w").write("\n".join(asm))