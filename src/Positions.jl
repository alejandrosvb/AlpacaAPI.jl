
#= Abstract -> PositionExchanges =#
# @enum PositionExchanges 

#= Abstract -> PositionSide =#
abstract type PositionSide end
##
struct long<:PositionSide end 
struct short<:PositionSide end 
##
PositionSide(::Type{long}, x::String="long") = x 
PositionSide(::Type{short}, x::String="short") = x 


struct Position
    asset_id::Union{UUID, Nothing}
    symbol::Union{String, Nothing}
    exchange::Union{String, Nothing} # Change String for PositionExchanges
    asset_class::Union{String, Nothing} #Change String for AssetClass
    avg_entry_price::Union{Real, Nothing}
    qty::Union{Real, Nothing}
    qty_available::Union{Real, Nothing}
    side::Union{Type{side} where {side<:PositionSide}, Nothing}
    market_value::Union{Real, Nothing}
    cost_basis ::Union{Real, Nothing}
    unrealized_pl::Union{Real, Nothing}
    unrealized_plpc::Union{Real, Nothing}
    unrealized_intraday_pl::Union{Real, Nothing}
    unrealized_intra_day_plpc::Union{Real, Nothing}
    current_price::Union{Real, Nothing}
    lastday_price::Union{Real, Nothing}
    change_today::Union{Real, Nothing}
end

function Base.show(io::IO, ::MIME"text/plain", a::Order)
    print(io, "Position\n-------\n")
    for fname in fieldnames(Order)
        field_value = getfield(a, Symbol(fname))
        if field_value !== nothing
            @printf(io, "* %-16.16s : %s\n", fname, getfield(a, Symbol(fname)))
        end
    end
end

function Position(d::Dict)
    asset_id = d["asset_id"] !== nothing ? UUID(d["asset_id"]) : nothing
    symbol = d["symbol"] !== nothing ? d["symbol"] : nothing
    exchange = d["exchange"] !== nothing ? d["asset_class"] : nothing
    # exchange = d["exchange"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["exchange"])) : nothing
    asset_class = d["asset_class"] !== nothing ? d["asset_class"] : nothing
    # asset_class = d["asset_class"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["asset_class"])) : nothing
    avg_entry_price = d["avg_entry_price"] !== nothing ? parse(Float64, d["avg_entry_price"]) : nothing
    qty = d["qty"] !== nothing ? parse(Int64, d["qty"]) : nothing
    qty_available = d["qty_available"] !== nothing ? parse(Int64, d["qty_available"]) : nothing
    side = d["side"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["side"])) : nothing
    market_value = d["market_value"] !== nothing ? parse(Float64, d["market_value"]) : nothing
    cost_basis = d["cost_basis"] !== nothing ? parse(Float64, d["cost_basis"]) : nothing
    unrealized_pl = d["unrealized_pl"] !== nothing ? parse(Float64, d["unrealized_pl"]) : nothing
    unrealized_plpc = d["unrealized_plpc"] !== nothing ? parse(Float64, d["unrealized_plpc"]) : nothing
    unrealized_intraday_pl = d["unrealized_intraday_pl"] !== nothing ? parse(Float64, d["unrealized_intraday_pl"]) : nothing
    unrealized_intraday_plpc = d["unrealized_intraday_plpc"] !== nothing ? parse(Float64, d["unrealized_intraday_plpc"]) : nothing
    current_price = d["current_price"] !== nothing ? parse(Float64, d["current_price"]) : nothing
    lastday_price = d["lastday_price"] !== nothing ? parse(Float64, d["lastday_price"]) : nothing
    change_today = d["change_today"] !== nothing ? parse(Float64, d["change_today"]) : nothing

    return Position(
        asset_id,
        symbol,
        exchange,
        asset_class,
        avg_entry_price,
        qty,
        qty_available,
        side,
        market_value,
        cost_basis,
        unrealized_pl,
        unrealized_plpc,
        unrealized_intraday_pl,
        unrealized_intraday_plpc,
        current_price,
        lastday_price,
        change_today
    )
end

#= API=# 

"""
    AlpcaApi.list_positions(c::Credentialss)
    List all open positions for your account
    See https://alpaca.markets/docs/api-documentation/api-v2/positions/
"""
function list_positions(c::Credentials)

    r = HTTP.get(join([ENDPOINT(c), "v2","positions"],'/'), HEADER(c))
    
    return Position.(JSON.parse(String(r.body)))
end

"""
    AlpcaApi.get_position(c::Credentials, symbol::String)
    Return a single open positions for your account
    See https://alpaca.markets/docs/api-documentation/api-v2/positions/
"""
function get_position(c::Credentials, symbol::Union{String})

    r = HTTP.get(join([ENDPOINT(c), "v2","positions", symbol],'/'), HEADER(c))

    return Position(JSON.parse(String(r.body)))
end


"""
    AlpcaApi.close_all_positions(c::Credentials, <optional args>)
    List all open positions for your account
    See https://alpaca.markets/docs/api-documentation/api-v2/positions/
"""
function close_all_positions(c::Credentials, cancel_orders::Union{Bool, Nothing})

    query = Dict{String, Any}()
    if cancel_orders
        query["cancel_orders"] = string(cancel_orders)
    end

    r = HTTP.delete(join([ENDPOINT(c), "v2","positions"],'/'), HEADER(c); query)
    
    return Order.(JSON.parse(String(r.body)))
end

"""
    AlpcaApi.close_position(c::Credentials, <optional args>)
    Close an open position in your account
    See https://alpaca.markets/docs/api-documentation/api-v2/positions/
"""
function close_position(c::Credentials, symbol::Union{String};
    qty::Union{Real, Nothing} = nothing,
    percentage::Union{Real, Nothing} = nothing,
    )

    query = Dict{String, Any}()

    if qty !== nothing && percentage === nothing
        query["qty"] = qty
    elseif qty === nothing && percentage !== nothing
        query["percentage"] = percentage
    else
        error("Cannot have both 'qty' ($qty) and 'percentage' ($percentage) when closing a position")
    end
    r = HTTP.delete(join([ENDPOINT(c), "v2","positions", symbol],'/'), HEADER(c); query=query)
    
    return Order(JSON.parse(String(r.body)))
end