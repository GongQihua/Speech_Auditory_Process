function dist = dtw(test, ref)
global x y_min y_max
global t r
global D d
global m n

t = test;
r = ref;
n = size(t,1);
m = size(r,1);

d = zeros(m,1);
D =  ones(m,1) * realmax;
D(1) = 0;

% compare the match
if (2*m-n<3) || (2*n-m<2)
	dist = realmax;
	return
end

xa = round((2*m-n)/3);
xb = round((2*n-m)*2/3);

if xb>xa
	for x = 1:xa
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xa+1):xb
		y_max = round(0.5*(x-n)+m);
		y_min = round(0.5*x);
		warp
	end
	for x = (xb+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
elseif xa>xb
	for x = 1:xb
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xb+1):xa
		y_max = 2*x;
		y_min = round(2*(x-n)+m);
		warp
	end
	for x = (xa+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
elseif xa==xb
	for x = 1:xa
		y_max = 2*x;
		y_min = round(0.5*x);
		warp
	end
	for x = (xa+1):n
		y_max = round(0.5*(x-n)+m);
		y_min = round(2*(x-n)+m);
		warp
	end
end
dist = D(m);

function warp
global x y_min y_max
global t r
global D d
global m n

d = D;
for y = y_min:y_max
	D1 = D(y);
	if y>1
		D2 = D(y-1);
	else
        D2 = realmax;
	end
	if y>2
		D3 = D(y-2);
	else
        D3 = realmax;
	end
    d(y) = sum((t(x,:)-r(y,:)).^2) + min([D1,D2,D3]);
end

D = d;