module AlpacaAPI

using HTTP, JSON, TimesDates
using  UUIDs, Printf
import Base.show

#= Abstract -> EndPoint =#
abstract type EndPoint end
##
struct PAPER <: EndPoint end
struct LIVE <: EndPoint end
##

#= EndPoint-> Alpaca API =#
EndPoint(::Type{T}) where {T<:EndPoint} = T == LIVE ? "https://api.alpaca.markets" : "https://paper-api.alpaca.markets"

#= Credentials =#
struct Credentials
    ENDPOINT::Type{T} where {T<:EndPoint}
    KEY_ID::String
    SECRET_KEY::String
end

#= Environment -> Credentials =#
credentials() = Credentials(
    getproperty(AlpacaAPI, Symbol(ENV["APCA_API_ENDPOINT"])),
    ENV["APCA_API_KEY_ID"],
    ENV["APCA_API_SECRET_KEY"]
)

#= Credentials -> Alpaca API =#
HEADER(c::Credentials)::Tuple = ("APCA-API-KEY-ID"=>c.KEY_ID, "APCA-API-SECRET-KEY"=>c.SECRET_KEY, "Content-Type"=>"application/json")
ENDPOINT(c::Credentials)::String = EndPoint(c.ENDPOINT)

#= API ENDPOINTS =#
include("Accounts.jl")
include("Orders.jl")
include("Positions.jl")

end 