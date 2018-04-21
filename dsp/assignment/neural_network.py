from encode import encoding

batch = encoding(64)

X, Y = next(batch);

print(len(X));