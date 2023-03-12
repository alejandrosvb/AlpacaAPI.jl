#= Abstract -> OrderStatusQuery =#
abstract type OrderStatusQuery end
##
struct open <: OrderStatusQuery end
struct closed <: OrderStatusQuery end
struct all <: OrderStatusQuery end
##

#= OrderStatusQuery -> Alpaca API =#
OrderStatusQuery(::Type{open}, x::String="open") = x
OrderStatusQuery(::Type{closed}, x::String="closed") = x
OrderStatusQuery(::Type{all}, x::String="all") = x


#= Abstract -> OrderDirectionQuery =#
abstract type OrderDirectionQuery end
##
struct asc <: OrderDirectionQuery end
struct desc <: OrderDirectionQuery end
##

#= OrderDirectionQuery -> Alpaca API =#
OrderDirectionQuery(::Type{asc}, x::String="asc") = x
OrderDirectionQuery(::Type{desc}, x::String="desc") = x


#= Abstract -> OrderSide =#
abstract type OrderSide end
##
struct buy <: OrderSide end 
struct sell <: OrderSide end
##

#= OrderSide -> Alpaca API =#
OrderSide(::Type{buy}, x::String="buy") = x
OrderSide(::Type{sell}, x::String="buy") = x


#= Abstract -> OrderType =#
abstract type OrderType end
##
struct market <: OrderType end 
struct limit <: OrderType end
struct stop <: OrderType end
struct stop_limit <: OrderType end
struct trailing_stop <: OrderType end 
##

#= OrderType -> Alpaca API =#
OrderType(::Type{market}, x::String="market") = x
OrderType(::Type{limit}, x::String="limit") = x
OrderType(::Type{stop}, x::String="stop") = x
OrderType(::Type{stop_limit}, x::String="stop_limit") = x
OrderType(::Type{trailing_stop}, x::String="trailing_stop") = x



#= Abstract -> OrderTimeInForce =#
abstract type OrderTimeInForce end 
##
struct day <: OrderTimeInForce end 
struct gtc <: OrderTimeInForce end 
struct opg <: OrderTimeInForce end 
struct cls <: OrderTimeInForce end 
struct ioc <: OrderTimeInForce end 
struct fok <: OrderTimeInForce end 
##

#= OrderTimeInForce -> Alpaca API =#
OrderTimeInForce(::Type{day}, x::String="day") = x
OrderTimeInForce(::Type{gtc}, x::String="gtc") = x
OrderTimeInForce(::Type{opg}, x::String="opg") = x
OrderTimeInForce(::Type{cls}, x::String="cls") = x
OrderTimeInForce(::Type{ioc}, x::String="ioc") = x
OrderTimeInForce(::Type{fok}, x::String="fok") = x


#= Abstract -> OrderClass =#
abstract type OrderClass end
##
struct simple <: OrderClass end 
struct bracket <: OrderClass end 
struct oco <: OrderClass end
struct oto <: OrderClass end 
##

#= OrderClass -> Alpaca API =#
OrderClass(::Type{simple}, x::String="") = x
OrderClass(::Type{bracket}, x::String="bracket") = x
OrderClass(::Type{oco}, x::String="oco") = x
OrderClass(::Type{oto}, x::String="oto") = x


#= Abstract -> OrderStatus =#
abstract type OrderStatus end 
##
struct new <: OrderStatus end 
struct partially_filled <: OrderStatus end 
struct filled <: OrderStatus end 
struct done_for_day <: OrderStatus end
struct canceled <: OrderStatus end
struct expired <: OrderStatus end
struct replaced <: OrderStatus end
struct pending_cancel <: OrderStatus end
struct pending_replace <: OrderStatus end
struct accepted <: OrderStatus end
struct pending_new <: OrderStatus end
struct accepted_for_bidding <: OrderStatus end
struct stopped <: OrderStatus end
struct rejected <:OrderStatus end
struct suspended <: OrderStatus end
struct calculated <: OrderStatus end 
##

#= OrderStatus -> Alpaca API =#
OrderStatus(::Type{new}, x::String="new") = x
OrderStatus(::Type{partially_filled}, x::String="partially_filled") = x
OrderStatus(::Type{filled}, x::String="filled") = x
OrderStatus(::Type{done_for_day}, x::String="done_for_day") = x
OrderStatus(::Type{canceled}, x::String="canceled") = x
OrderStatus(::Type{expired}, x::String="expired") = x
OrderStatus(::Type{replaced}, x::String="replaced") = x
OrderStatus(::Type{pending_cancel}, x::String="pending_cancel") = x
OrderStatus(::Type{pending_replace}, x::String="pending_replace") = x
OrderStatus(::Type{accepted}, x::String="accepted") = x
OrderStatus(::Type{pending_new}, x::String="pending_new") = x
OrderStatus(::Type{accepted_for_bidding}, x::String="accepted_for_bidding") = x
OrderStatus(::Type{stopped}, x::String="stopped") = x
OrderStatus(::Type{rejected}, x::String="rejected") = x
OrderStatus(::Type{suspended}, x::String="suspended") = x
OrderStatus(::Type{calculated}, x::String="calculated") = x


#= Order =#
struct Order
    id::Union{UUID, Nothing}
    client_order_id::Union{UUID, Nothing}
    created_at::Union{TimeDateZone, Nothing}
    updated_at::Union{TimeDateZone, Nothing}
    submitted_at::Union{TimeDateZone, Nothing}
    filled_at::Union{TimeDateZone, Nothing}
    expired_at::Union{TimeDateZone, Nothing}
    canceled_at::Union{TimeDateZone, Nothing}
    failed_at::Union{TimeDateZone, Nothing}
    replaced_at::Union{TimeDateZone, Nothing}
    replaced_by::Union{UUID, Nothing}
    replaces::Union{UUID, Nothing}
    asset_id::Union{UUID, Nothing}
    symbol::Union{String, Nothing}
    asset_class::Union{String, Nothing}
    notional::Union{Real, Nothing}
    qty::Union{Real, Nothing}
    filled_qty::Union{Real, Nothing}
    filled_avg_price::Union{Real, Nothing}
    order_class::Union{Type{order_class} where {order_class<:OrderClass}, Nothing}
    type::Union{Type{type} where {type<:OrderType}, Nothing}
    side::Union{Type{side} where {side<:OrderSide}, Nothing}
    time_in_force::Union{Type{time_in_force} where {time_in_force<:OrderTimeInForce}, Nothing}
    limit_price::Union{Real, Nothing}
    stop_price::Union{Real, Nothing}
    status::Union{Type{status} where {status<:OrderStatus}, Nothing}
    extended_hours::Union{Bool, Nothing}
    legs::Union{Vector{Order}, Nothing}
    trail_percent::Union{Real, Nothing}
    trail_price::Union{Real, Nothing}
    hwm::Union{Real, Nothing}
end


function Base.show(io::IO, ::MIME"text/plain", a::Order)
    print(io, "Order\n-------\n")
    for fname in fieldnames(Order)
        field_value = getfield(a, Symbol(fname))
        if field_value !== nothing
            @printf(io, "* %-16.16s : %s\n", fname, getfield(a, Symbol(fname)))
        end
    end
end


#= Alpaca API -> Order =# 
function Order(d::Dict)
        id = d["id"] !== nothing ? UUID(d["id"]) : nothing
        client_order_id = d["client_order_id"]!== nothing ? UUID(d["client_order_id"]) : nothing
        created_at = d["created_at"] !== nothing ? TimeDateZone(d["created_at"]) : nothing
        updated_at = d["updated_at"] !== nothing ? TimeDateZone(d["updated_at"]) : nothing
        submitted_at = d["submitted_at"] !== nothing ? TimeDateZone(d["submitted_at"]) : nothing
        filled_at = d["filled_at"] !== nothing ? TimeDateZone(d["filled_at"]) : nothing
        expired_at = d["expired_at"] !== nothing ? TimeDateZone(d["expired_at"]) : nothing
        canceled_at = d["canceled_at"] !== nothing ? TimeDateZone(d["canceled_at"]) : nothing
        failed_at = d["failed_at"] !== nothing ? TimeDateZone(d["failed_at"]) : nothing
        replaced_at = d["replaced_at"] !== nothing ? TimeDateZone(d["replaced_at"]) : nothing
        replaced_by = d["replaced_by"] !== nothing ? UUID(d["replaced_by"]) : nothing
        replaces = d["replaces"] !== nothing ? UUID(d["replaces"]) : nothing
        asset_id = d["asset_id"] !== nothing ? UUID(d["asset_id"]) : nothing
        symbol = d["symbol"] !== nothing ? d["symbol"] : nothing
        asset_class = d["asset_class"] !== nothing ? d["asset_class"] : nothing
        notional = d["notional"] !== nothing ? parse(Float64, d["notional"]) : nothing
        qty = d["qty"] !== nothing ? parse(Float64, d["qty"]) : nothing
        filled_qty = d["filled_qty"] !== nothing ? parse(Float64, d["filled_qty"]) : nothing
        filled_avg_price = d["filled_avg_price"] !== nothing ? parse(Float64, d["filled_avg_price"]) : nothing
        order_class = d["order_class"] === nothing || d["order_class"] === "" ? nothing : getproperty(AlpacaAPI, Symbol(d["order_class"])) 
        type = d["type"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["type"])) : nothing
        side = d["side"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["side"])) : nothing 
        time_in_force = d["time_in_force"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["time_in_force"])) : nothing
        limit_price = d["limit_price"] !== nothing ? parse(Float64, d["limit_price"]) : nothing
        stop_price = d["stop_price"] !== nothing ? parse(Float64, d["stop_price"]) : nothing
        status = d["status"] !== nothing ? getproperty(AlpacaAPI, Symbol(d["status"])) : nothing 
        extended_hours = d["extended_hours"] !== nothing ? Bool(d["extended_hours"]) : nothing
        legs = d["legs"] !== nothing ? Vector{Order}(d["legs"]) : nothing
        trail_percent = d["trail_percent"] !== nothing ? parse(Float64, d["trail_percent"]) : nothing
        trail_price = d["trail_price"] !==  nothing ? parse(Float64, d["trail_price"]) : nothing
        hwm = d["hwm"] !== nothing ? parse(Float64, d["hwm"]) : nothing

    return Order(
        id,
        client_order_id,
        created_at,
        updated_at,
        submitted_at,
        filled_at,
        expired_at,
        canceled_at,
        failed_at,
        replaced_at,
        replaced_by,
        replaces,
        asset_id,
        symbol,
        asset_class,
        notional,
        qty,
        filled_qty,
        filled_avg_price,
        order_class,
        type,
        side,
        time_in_force,
        limit_price,
        stop_price,
        status,
        extended_hours,
        legs,
        trail_percent,
        trail_price,
        hwm
        #source
        #order_type: Deprecated
        #subtag 
    )
end

#= CanceledOrder =#
struct CanceledOrder
    id::UUID
    status::Type{order_status} where {order_status<:OrderStatus}
    order::Order
end


function Base.show(io::IO, ::MIME"text/plain", a::CanceledOrder)
    print(io, "Canceled Order\n-------\n")
    for fname in fieldnames(CanceledOrder)
        field_value = getfield(a, Symbol(fname))
        if field_value !== nothing
            @printf(io, "* %-16.16s : %s\n", fname, getfield(a, Symbol(fname)))
        end
    end
end

#= Alpaca API -> CanceledOrder =#
# CanceledOrder(d::Dict) = CanceledOrder(UUID(d["id"]), )


#= TakeProfit =#
struct TakeProfit
    limit_price::Union{Real, Nothing}
end

#= Alpaca API -> TakeProfit =#
TakeProfit(limit_price::Real) = TakeProfit(limit_price)

#= StopLoss =#
struct StopLoss
    stop_price::Real
    limit_price::Union{Real,Nothing}
end

#= Alpaca API -> StopLoss =#
StopLoss(stop_price::Real) = StopLoss(stop_price, nothing)


#= Julia -> Alpaca Api -> Julia =#
"""
    AlpacaApi.list_orders(c::Credentials, <optional args>)
    List all orders for your account.
    See https://alpaca.markets/docs/api-documentation/api-v2/orders/
"""
function list_orders(c::Credentials;
    status::Union{Nothing, Type{status} where {status<:OrderStatusQuery}} = nothing, # Order status to be queried. open, closed or all. Defaults to open.
    limit::Union{Nothing,Int}           = nothing, # The maximum number of orders in response. Defaults to 50 and max is 500.
    after::Union{Nothing,TimeDateZone}  = nothing, # The response will include only ones submitted after this timestamp (exclusive.)
    until::Union{Nothing,TimeDateZone}  = nothing, # The response will include only ones submitted until this timestamp (exclusive.)
    direction::Union{Nothing, Type{direction} where {direction<:OrderDirectionQuery}} = nothing, # The chronological order of response based on the submission time. asc or desc. Defaults to desc.
    nested::Union{Nothing,Bool}         = nothing, # If true, the result will roll up multi-leg orders under the legs field of primary order.
    symbols::Union{Nothing,String}      = nothing, # A comma-separated list of symbols to filter by (ex. “AAPL,TSLA,MSFT”).
    )::Vector{Order} 

    query = Dict{String, Any}()

    if (status       !== nothing) query["status"]    =  OrderStatusQuery(status)     end
    if (limit        !== nothing) query["limit"]      =  limit      end
    if (after        !== nothing) query["after"]      =  after      end
    if (until        !== nothing) query["until"]      =  until      end
    if (direction    !== nothing) query["direction"]  =  OrderDirectionQuery(direction)  end
    if (nested       !== nothing) query["nested"]     =  nested     end
    if (symbols      !== nothing) query["symbols"]    =  symbols    end

    r = HTTP.get(join([ENDPOINT(c), "v2","orders"],'/'), HEADER(c); query = query)

    return Order.(JSON.parse(String(r.body)))

end

#= Julia -> Alpaca Api -> Julia =#
"""
    AlpacaApi.order(c::Credentials, symbol, qty, side, type, time_in_force, <optional args>)
    Request a new order.
    See https://alpaca.markets/docs/api-documentation/api-v2/orders/
"""
function order(c::Credentials,
    symbol::String,
    qty::Int,
    side::Type{side} where {side<:OrderSide},
    type::Type{type} where {type<:OrderType},
    time_in_force::Type{time_in_force} where {time_in_force<:OrderTimeInForce};
    limit_price::Union{Real,Nothing}=nothing,   # Required if type is limit or stop_limit
    stop_price::Union{Real,Nothing}=nothing,    # Required if type is stop or stop_limit
    trail_price::Union{Real,Nothing}=nothing,   # Required if type is trailing_stop and trail_percent is nothing
    trail_percent::Union{Real,Nothing}=nothing, # Required if type is trailing_stop and trail_price is nothing
    extended_hours::Bool=false,
    client_order_id::Union{UUID,Nothing}=nothing,
    order_class::Union{Type{order_class} where {order_class<:OrderClass}, Nothing}=nothing,
    take_profit::Union{Type{take_profit} where {take_profit<:TakeProfit}, Nothing}=nothing,
    stop_loss::Union{Type{stop_loss} where {stop_loss<:StopLoss}, Nothing}=nothing
    )

    body = Dict{String, Any}(
        "symbol"        => symbol,
        "qty"           => string(qty),
        "side"          => OrderSide(side),
        "type"          => OrderType(type),
        "time_in_force" => OrderTimeInForce(time_in_force)
    )

    if type == limit || type == stop_limit
        body["limit_price"] = limit_price
    end
    if type == stop || type == stop_limit
        body["stop_price"] = stop_price
    end
    if type == trailing_stop
        if trail_percent === nothing && trail_price !== nothing
            body["trail_price"] = trail_price
        elseif trail_percent !== nothing && trail_price === nothing
            body["trail_percent"] = trail_percent
        else
            error("Cannot have both `trail_price` ($trail_price) and `trail_percent` ($trail_percent) defined when type is $type")
        end
    end

    body["extended_hours"] = extended_hours === nothing ? nothing : extended_hours 
    body["client_order_id"] = client_order_id === nothing ? nothing : client_order_id 
    body["order_class"] = order_class === nothing ? nothing : OrderClass(order_class)
    body["take_profit"] = take_profit === nothing ? nothing : TakeProfit(take_profit)
    body["stop_loss"] = stop_loss === nothing ? nothing : StopLoss(stop_loss) 

    r = HTTP.post(join([ENDPOINT(c), "v2","orders"],'/'), HEADER(c); body=JSON.json(body))

    return Order(JSON.parse(String(r.body)))

end

#= Julia -> Alpaca Api -> Julia =#
"""
    AlpacaApi.get_order(c::Credentials, order_id, nested=false)
    Return a single order with a given ID.
    See https://alpaca.markets/docs/api-documentation/api-v2/orders/
"""
function get_order(c::Credentials; 
    order_id::Union{UUID, Nothing}=nothing,
    client_order_id::Union{UUID, Nothing}=nothing,
    nested::Bool=false
    )::Order

    query = Dict{String,String}("nested"=>string(nested))

    if order_id === nothing && client_order_id !== nothing
        order_id = client_order_id
    elseif order_id !== nothing && client_order_id === nothing
        order_id = order_id
    else
        error("Cannot have both `order_id` ($order_id) and `client_order_id` ($client_order_id)")
    end

    r = HTTP.get(join([ENDPOINT(c), "v2","orders",HTTP.URIs.escapeuri(string(order_id))],'/'), HEADER(c); query = query)

    return Order(JSON.parse(String(r.body)))

end

#= Julia -> Alpaca Api -> Julia =#
"""
    AlpacaApi.update_order(c::Credentials, order_id, <see get_order args>)
    Update an order with a given ID.
    See https://alpaca.markets/docs/api-documentation/api-v2/orders/
"""
function replace_order(c::Credentials, 
    order::Order;
    qty::Union{Int,Nothing}=nothing,
    time_in_force::Union{Type{order_time_in_force} where {order_time_in_force<:OrderTimeInForce}, Nothing}=nothing,
    limit_price::Union{Real,Nothing}=nothing,   # Required if type is limit or stop_limit
    stop_price::Union{Real,Nothing}=nothing,    # Required if type is stop or stop_limit
    trail_price::Union{Real,Nothing}=nothing,   # Required if type is trailing_stop and trail_percent is nothing
    trail_percent::Union{Real,Nothing}=nothing, # Required if type is trailing_stop and trail_price is nothing
    client_order_id::Union{UUID, Nothing}=nothing,
    )::Order

    body = Dict{String, Any}()

    if (qty           !== nothing) body["qty"]           = qty           end
    if (time_in_force !== nothing) body["time_in_force"] = OrderTimeInForce(time_in_force) end

    if order.type == limit || order.type == stop_limit
        body["limit_price"] = limit_price
    end
    if order.type == stop || order.type == stop_limit
        body["stop_price"] = stop_price
    end
    if order.type == trailing_stop
        if trail_percent === nothing && trail_price !== nothing
            body["trail"] = trail_price     # For update, the parameter is "trail" for both
        elseif trail_percent !== nothing && trail_price === nothing
            body["trail"] = trail_percent   # For update, the parameter is "trail" for both
        else
            error("Cannot have both `trail_price` ($trail_price) and `trail_percent` ($trail_percent) defined when type is $type")
        end
    end

    if (client_order_id !== nothing) body["client_order_id"] = client_order_id end

    r = HTTP.patch(join([ENDPOINT(c), "v2","orders",HTTP.URIs.escapeuri(string(order.id))],'/'), HEADER(c); body=JSON.json(body))

    return Order(JSON.parse(String(r.body)))

end


function cancel_order(c::Credentials, order::Order)
    r = HTTP.delete(join([ENDPOINT(c), "v2","orders",HTTP.URIs.escapeuri(string(order.id))],'/'), HEADER(c))
    if r.status == 204
        println(r.status)
        println(OrderStatus(order.status))
        println("The order with id $(order.id) has been canceled")
    elseif r.status == 422
        println(r.status)
        println(OrderStatus(order.status))
        println("The order with id $(order.id) cannot be canceled since it is $(OrderStatus(order.status))")
    elseif r.status == 404
        println(r.status)
        println(OrderStatus(order.status))
        println("The order with id $(order.id) was not found")
    end
    return get_order(c; order_id = order.id)
    return r
end

#= Julia -> Alpaca Api -> Julia =#
"""
    AlpacaApi.cancel_all_orders(c::Credentials)
    Cancel all open orders.
    See https://alpaca.markets/docs/api-documentation/api-v2/orders/
"""
function cancel_all_orders(c::Credentials)
    println("All orders currently in line have been canceled")
    r = HTTP.delete(join([ENDPOINT(c), "v2","orders"],'/'), HEADER(c))
    return JSON.parse(String(r.body))
end