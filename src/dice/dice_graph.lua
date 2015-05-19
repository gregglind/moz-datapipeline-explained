-- https://gist.githubusercontent.com/rafrombrc/e7c5f2085a04d69e584/raw/7d2422ef5595ae4dd1bf694ecef1fbf9df4e2295/dice_graph.lua *.

require("circular_buffer")
require("cjson")

-- # dateapipeline specific functions
--
-- read_config
-- process_message
-- read_message
-- inject_payload


_PRESERVATION_VERSION = read_config("preservation_version") or 0
_PRESERVATION_VERSION = _PRESERVATION_VERSION + 0 -- bump when code changes invalidate data

local rows = read_config("rows") or 120
local sec_per_row = read_config("sec_per_row") or 10

cbuf = circular_buffer.new(rows, 11, sec_per_row)
cbuf_idxs = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"}
cbuf_hdrs = {}
for idx, str in ipairs(cbuf_idxs) do
    cbuf_hdrs[str] = cbuf:set_header(idx, str, "count")
end

local json_output = {}



-- runs on every message matching the filter
function process_message()
	local payload = read_message("Payload")
	local ts = read_message("Timestamp")
    local ok, values = pcall(cjson.decode, payload)
    if not ok then
        return -1
    end

    for i, v in ipairs(values) do
        cbuf:add(ts, i, v)
        json_output[tostring(i+1)] = v
    end
    return 0
end

-- runs every "ticker_interval" ns
function timer_event(ns)
    inject_payload("cbuf", "Dice Graph", cbuf)
    local ok, output = pcall(cjson.encode, json_output)
    if ok then
        inject_payload("txt", "Dice JSON", output)
    else
        inject_payload("txt", "Dice JSON", cjson.encode({error = "true"}))
    end
end
