function selectedInstance = Rand(U,batchSize)
perm = randperm(length(U));
selectedInstance = U(perm(1:batchSize)); 
