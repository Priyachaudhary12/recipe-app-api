def add(x,y):
    return x+y

def subtract(x,y):
    return y-x

def num_check(my_list):
    results=[]
    for i in my_list:
        if i%2==0:
            results.append(f"{i} is an even number")

        else:
            results.append(f"{i} is an odd number")

    return results        