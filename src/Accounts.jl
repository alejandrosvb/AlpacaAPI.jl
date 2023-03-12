#= Abstract -> AccountStatus =#
abstract type AccountStatus end 
##
struct ONBOARDING <: AccountStatus end
struct SUBMISSION_FAILED <: AccountStatus end
struct SUBMITTED <: AccountStatus end
struct ACCOUNT_UPDATED <: AccountStatus end 
struct APPROVAL_PENDING <: AccountStatus end 
struct ACTIVE <: AccountStatus end 
struct REJECTED <: AccountStatus end 
struct PAPER_ONLY <: AccountStatus end 
##

#= AccountStatus -> Alpaca API =#
AccountStatus(::Type{status} where {status<:AccountStatus}) = string(Symbol(T))
 

#= Account =#
struct Account
    id::UUID
    account_number::String 
    status::Type{status} where {status<:AccountStatus}
    crypto_status::Type{crypto_status} where {crypto_status<:AccountStatus}
    currency::String
    cash::Real
    non_marginable_buying_power::Real
    accrued_fees::Real
    pending_transfer_in::Real
    # pending_transfer_out::Real
    pattern_day_trader::Bool
    trade_suspended_by_user::Bool 
    trading_blocked::Bool
    transfers_blocked::Bool
    account_blocked::Bool
    created_at::TimeDateZone
    shorting_enabled::Bool
    long_market_value::Real
    short_market_value::Real
    equity::Real
    last_equity::Real
    multiplier::Integer
    buying_power::Real
    initial_margin::Real
    maintenance_margin::Real
    sma::Real
    daytrade_count::Integer
    last_maintenance_margin::Real
    daytrading_buying_power::Real
    regt_buying_power::Real
end


function Base.show(io::IO, ::MIME"text/plain", a::Account)
    print(io, "Account\n-------\n")
    for fname in fieldnames(Account)
        field_value = getfield(a, Symbol(fname))
        if field_value !== nothing
            @printf(io, "* %-23.23s : %s\n", fname, getfield(a, Symbol(fname)))
        end
    end
end

#= Alpaca API -> Account =#
function Account(d::Dict)
    return Account(
        UUID(d["id"]),
        d["account_number"],
        getproperty(AlpacaAPI, Symbol(d["status"])),
        getproperty(AlpacaAPI, Symbol(d["crypto_status"])),
        d["currency"],
        parse(Float64, d["cash"]),
        parse(Float64, d["non_marginable_buying_power"]),
        parse(Float64, d["accrued_fees"]),
        parse(Float64, d["pending_transfer_in"]), 
        # parse(Float64, d["pending_transfer_out"])
        d["pattern_day_trader"],
        d["trade_suspended_by_user"],
        d["trading_blocked"],
        d["transfers_blocked"],
        d["account_blocked"],
        TimeDateZone(d["created_at"]),
        d["shorting_enabled"],
        parse(Float64, d["long_market_value"]),
        parse(Float64, d["short_market_value"]),
        parse(Float64, d["equity"]),
        parse(Float64, d["last_equity"]),
        parse(Int64, d["multiplier"]),
        parse(Float64, d["buying_power"]),
        parse(Float64, d["initial_margin"]),
        parse(Float64, d["maintenance_margin"]),
        parse(Float64, d["sma"]),
        d["daytrade_count"],
        parse(Float64, d["last_maintenance_margin"]),
        parse(Float64, d["daytrading_buying_power"]),
        parse(Float64, d["regt_buying_power"])
    )
end

#= JULIA -> ALPACA API -> JULIA =#
"""
    AlpacaApi.account(c::Credentials)
    List account information.
    See https://alpaca.markets/docs/api-documentation/api-v2/account/
"""
function account(c::Credentials)
    r = HTTP.get(join([ENDPOINT(c), "v2","account"],'/'), HEADER(c))
    return Account(JSON.parse(String(r.body)))
end