-- ============================================
-- VM Obfuscator 総合テストケース
-- ============================================

print("=== 1. 文字列操作 ===")
local s1 = "Hello\tWorld\n"
local s2 = 'It\'s a "test"'
local s3 = [[
multi
line
string]]
local s4 = string.format("%d + %d = %d", 10, 20, 10 + 20)
local s5 = ("abc"):rep(3) .. " end"
local s6 = string.byte("A")
local s7 = string.char(65, 66, 67)
print(s1, s2, s3, s4, s5, s6, s7)

print("=== 2. ビット演算 ===")
local a = 0xFF
local b = 0x0F
local band_r  = bit32.band(a, b)
local bor_r   = bit32.bor(a, b)
local bxor_r  = bit32.bxor(a, b)
local bnot_r  = bit32.bnot(0)
local lsh_r   = bit32.lshift(1, 4)
local rsh_r   = bit32.rshift(256, 4)
print("band:", band_r, "bor:", bor_r, "bxor:", bxor_r)
print("bnot:", bnot_r, "lshift:", lsh_r, "rshift:", rsh_r)

print("=== 3. クロージャ / upvalue ===")
local function makeCounter(start)
    local count = start or 0
    return {
        inc = function() count = count + 1 end,
        dec = function() count = count - 1 end,
        get = function() return count end,
    }
end
local c = makeCounter(10)
c.inc(); c.inc(); c.dec()
print("counter:", c.get()) -- 11

local shared = 0
local function addShared(n) shared = shared + n end
local function getShared() return shared end
addShared(5); addShared(3)
print("shared:", getShared()) -- 8

print("=== 4. テーブル操作 ===")
local t = {10, 20, 30, key = "val", nested = {1, 2, 3}}
print(t[1], t[2], t[3])
print(t.key, t["key"])
print(t.nested[2])
local k = "key"
print(t[k])
table.insert(t, 99)
print("len:", #t)
for i, v in ipairs(t) do
    print(i, v)
end

print("=== 5. 多値返り値 / vararg ===")
local function multi()
    return 1, 2, 3
end
local ma, mb, mc = multi()
print(ma, mb, mc) -- 1 2 3

local function sum(...)
    local args = {...}
    local total = 0
    for _, v in ipairs(args) do total = total + v end
    return total
end
print("sum:", sum(1, 2, 3, 4, 5)) -- 15

local vals = {multi()}
print("vals len:", #vals)
print(table.unpack(vals))

print("=== 6. pcall / エラー処理 ===")
local ok1, err1 = pcall(function()
    error("test error", 2)
end)
print(ok1, err1)

local function msgh(e) return "caught: " .. tostring(e) end
local ok2, msg2 = xpcall(function()
    error("boom")
end, msgh)
print(ok2, msg2)

local ok3, val3 = pcall(function()
    return 42
end)
print(ok3, val3)

print("=== 全テスト完了 ===")
