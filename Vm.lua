-- Obfuscation by YAJU
local OlIO_11_OOI1ll={(function()local _t={86,87,88,89,90,91,92,93};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={94,95,96,97,98,99,100,101,102,103,104};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={105,106,107,108,109,110,111,118,119};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={120,121,122,123,124,125,126,127,128};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={129,130,131,132,133,134,135,136,137,138,139,140,141};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={142,143,69,70,71,72,73,74,75,76,77,78,64,68};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)(),(function()local _t={82};local _r={};for _i=1,#_t do _r[_i]=string.char(_t[_i]-21)end;return table.concat(_r)end)()};
local lI01llIII00lIO_0l=table.concat(OlIO_11_OOI1ll)
local lOIlI_10__0_IOII={}
for IlO1O_1_1OlI1ll_I=1,#lI01llIII00lIO_0l do lOIlI_10__0_IOII[string.byte(lI01llIII00lIO_0l,IlO1O_1_1OlI1ll_I,IlO1O_1_1OlI1ll_I)]=IlO1O_1_1OlI1ll_I-1 end
local function lO0l1l_lOI10O1I_0I_(lO1OIl_l0I1lOI1)local l1llII__II1__0_,O_Ol__I1OlI,IOl0I1l0Il0lllII1l={},1,#lO1OIl_l0I1lOI1
for IlO1O_1_1OlI1ll_I=1,IOl0I1l0Il0lllII1l,4 do local lI1O1OOOIl_OlI,II11I1ll01O_,OI1llOOI0O1l,I_101111IOO111ll=lOIlI_10__0_IOII[string.byte(lO1OIl_l0I1lOI1,IlO1O_1_1OlI1ll_I,IlO1O_1_1OlI1ll_I)],lOIlI_10__0_IOII[string.byte(lO1OIl_l0I1lOI1,IlO1O_1_1OlI1ll_I+1,IlO1O_1_1OlI1ll_I+1)],lOIlI_10__0_IOII[string.byte(lO1OIl_l0I1lOI1,IlO1O_1_1OlI1ll_I+2,IlO1O_1_1OlI1ll_I+2)],lOIlI_10__0_IOII[string.byte(lO1OIl_l0I1lOI1,IlO1O_1_1OlI1ll_I+3,IlO1O_1_1OlI1ll_I+3)]
if not lI1O1OOOIl_OlI or not II11I1ll01O_ then break end
l1llII__II1__0_[O_Ol__I1OlI]=string.char((lI1O1OOOIl_OlI*4+math.floor(II11I1ll01O_/16))%256)O_Ol__I1OlI=O_Ol__I1OlI+1
if not OI1llOOI0O1l then break end
l1llII__II1__0_[O_Ol__I1OlI]=string.char(((II11I1ll01O_%16)*16+math.floor(OI1llOOI0O1l/4))%256)O_Ol__I1OlI=O_Ol__I1OlI+1
if not I_101111IOO111ll then break end
l1llII__II1__0_[O_Ol__I1OlI]=string.char(((OI1llOOI0O1l%4)*64+I_101111IOO111ll)%256)O_Ol__I1OlI=O_Ol__I1OlI+1 end
return table.concat(l1llII__II1__0_)end

local OlO__O1lIl1lI1=(rawget(_G,"loadstr".."ing") or loadstring)
local O1_0O1_I1Ol11_O0="cHJpbnQoImhlbGxvIik="
O1_0O1_I1Ol11_O0=lO0l1l_lOI10O1I_0I_(O1_0O1_I1Ol11_O0)
local _f,_e=OlO__O1lIl1lI1(O1_0O1_I1Ol11_O0);if _f then _f() else error(_e) end
