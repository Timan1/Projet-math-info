#fonction qui value les poids des arretes
function valuation(a::Char, b::Char )
  if a=='A' && b=='A'
    return 1
  elseif    a=='A' && b=='B'
      return 3
  elseif  a=='A' && b=='C'
        return 0
  elseif  a=='B' && b=='A'
              return 3
  elseif  a=='B' && b=='B'
                  return 5
  elseif  a=='B' && b=='C'
                      return 0
  elseif  a=='C' && b=='A'
                        return 0
  elseif  a=='C' && b=='B'
                          return 0
  elseif  a=='C' && b=='C'
                            return 0
  else
    throw("Test : $a et $b")
  end
  end
  #Fonction pour lire un fichier
function lire_fichier(nom::String)

  compteurligne =0
file = open(nom)
    x=readline(file)
    x=readline(file)
    r=parse(Int64,SubString(x,8))
    x=readline(file)
    s=parse(Int64,SubString(x,7))
    x=readline(file)
    m= Matrix{Char}(undef, r, s)
    for ln in eachline(file)
    compteurligne += 1
    compteur_colonne=0
    for p in ln
      compteur_colonne +=1
    if p=='@'
        m[compteurligne, compteur_colonne] = 'C'
        elseif p=='.'
        m[compteurligne,compteur_colonne] = 'A'

    end
end
end
return m

end
function voisin(x::Tuple{Int64,Int64},graph::Matrix{Char})
	v::Vector{Tuple{Int64,Int64}} = Vector{Tuple{Int64,Int64}}(undef, 0)
	if x[1] > 1
	if valuation(graph[x[1], x[2]],graph[ (x[1] -1 ), x[2] ]) != 0
		push!(v, (x[1] -1, x[2]) )
	end
	end
	if x[1] < size(graph, 1)
	if valuation(graph[x[1], x[2]], graph[ (x[1] +1), x[2]] ) != 0
	  push!(v, (x[1] +1, x[2]))
	end
	end
	if x[2] > 1
	if valuation(graph[x[1], x[2]],graph[ x[1] ,(x[2]-1)]) != 0
	   push!(v,  (x[1] ,x[2]-1))
	end	 
	end
	if x[2] < size(graph, 2)
	if valuation(graph[x[1], x[2]],graph[ x[1], (x[2]+1) ]) !=0  
	 push!(v, (x[1], x[2]+1))
	end
	end
	return v
end
	 
function Dijkstra(graph::Matrix{Char},depart::Tuple{Int64,Int64}, arrivee::Tuple{Int64,Int64})
distance::Matrix{Int64} = zeros(Int64, size(graph,1), size(graph,2) )
par::Matrix{Tuple{Int64,Int64}} =Matrix{Tuple{Int64,Int64}}(undef, size(graph,1), size(graph,2) )
a::Vector{Tuple{Int64,Int64}} = [ depart ]
argmin::Tuple{Int64,Int64} = depart
nb::Int64 = 1
while argmin !=arrivee
println("feuilles : $a")
argmin = a[1]
min = distance[a[1][1], a[1][2]]
indmin = 1
for j in 1:length(a)
if distance[a[j][1], a[j][2]] < min
	min= distance[a[j][1], a[j][2]]
	argmin = a[j]
	indmin = j
end
end
println("dev : $argmin")
for v in voisin(argmin ,graph)
if distance[v[1], v[2]] == 0 && v != depart
distance[v[1], v[2]] = distance[argmin[1], argmin[2]] + valuation( graph[argmin[1], argmin[2]], graph[v[1],v[2]] )
par[v[1],v[2]] = argmin
push!(a, v)
elseif distance[v[1], v[2]] > distance[argmin[1], argmin[2]] + valuation( graph[argmin[1], argmin[2]], graph[v[1],v[2]] )
distance[v[1], v[2]] = distance[argmin[1], argmin[2]] + valuation( graph[argmin[1], argmin[2]], graph[v[1],v[2]] )
par[v[1],v[2]] = argmin
end
end
deleteat!( a, indmin )
end
for i in distance
  if i > 0
    nb+=1
  end
end
return distance, par, nb
end

function main()
m = lire_fichier("test.map")
d,par,n = Dijkstra(m, (1,2), (5,1) )
println("distance : $(d[5,1])" )
println("états visités : $n")
p::Tuple{Int64, Int64} = (5,1)
while p != (1,2)
    print("$p <- ")
    p = par[p[1], p[2]]
end
println("$p")
end
