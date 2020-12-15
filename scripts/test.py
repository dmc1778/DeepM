import re


def apply_mutations(mystring):
    #matches = re.findall(r'.*?\((.*?)\)', mystring)
    mystring = re.sub(r'\((.*)\)', '', mystring)
    print(mystring)


apply_mutations('x = xmalloc(sizeof(x*))')
