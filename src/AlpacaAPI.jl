module AlpacaAPI

using HTTP, JSON, TimesDates
using  UUIDs, Printf
import Base.show

#= Client =# 
abstract type EndPoint end
##
struct PAPER <: EndPoint end
struct LIVE <: EndPoint end
##
EndPoint(::Type{T}) where {T<:EndPoint} = T == LIVE ? "https://api.alpaca.markets" : "https://paper-api.alpaca.markets"

abstract type KeyID <: AbstractString end
abstract type SecretKey <: AbstractString end 

struct Credentials
    KEY_ID::KeyID
    SECRET_KEY::SecretKey
end

Credentials() = Credentials(ENV["APCA_API_KEY_ID"], ENV["APCA_API_SECRET_KEY"])

Credentials(key_id::KeyID, secret_key::SecretKey) = Credentials(key_id, secret_key)


struct AlpacaClient
    ENDPOINT::Type{T} where {T<:EndPoint}
    CREDENTIALS::Credentials
end

AlpacaClient() = AlpacaClient(
    getproperty(AlpacaAPI, Symbol(ENV["APCA_API_ENDPOINT"])),
    ENV["APCA_API_CREDENTIALS"]
)

AlpacaClient(credentials::Credentials) = AlpacaClient(
    getproperty(AlpacaAPI, Symbol(ENV["APCA_API_ENDPOINT"])),
    credentials
    )

AlpacaClient(endpoint::EndPoint, credentials::Credentials) = AlpacaClient(
    getproperty(AlpacaAPI, Symbol(endpoint)),
    credentials)

AlpacaClient(endpoint::EndPoint, key_id::KeyID, secret_key::SecretKey) = AlpacaClient(
    getproperty(AlpacaAPI, Symbol(endpoint)),
    Credentials(key_id, secret_key)
)


HEADER(c::Credentials)::Tuple = ("APCA-API-KEY-ID"=>c.KEY_ID, "APCA-API-SECRET-KEY"=>c.SECRET_KEY, "Content-Type"=>"application/json")
ENDPOINT(c::Credentials)::String = EndPoint(c.ENDPOINT)

#= API ENDPOINTS =#
include("Accounts.jl")
include("Orders.jl")
include("Positions.jl")

end 
