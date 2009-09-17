#! /usr/bin/lua
--
-- lua-TestMore : <http://testmore.luaforge.net/>
--
-- Copyright (C) 2009, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Debug Library

=head2 Synopsis

    % prove 309-debug.t

=head2 Description

Tests Lua Debug Library

See "Lua 5.1 Reference Manual", section 5.9 "The Debug Library",
L<http://www.lua.org/manual/5.1/manual.html#5.9>.

See "Programming in Lua", section 23 "The Debug Library".

=cut

]]

require 'Test.More'

plan(25)

is(debug.getfenv(3.14), nil, "function getfenv")
local function f () end
type_ok(debug.getfenv(f), 'table')
is(debug.getfenv(f), _G)
type_ok(debug.getfenv(print), 'table')
is(debug.getfenv(print), _G)

a = coroutine.create(function () return 1 end)
type_ok(debug.getfenv(a), 'table', "function getfenv (thread)")
is(debug.getfenv(a), _G)

t = {}
is(debug.getmetatable(t), nil, "function getmetatable")
t1 = {}
setmetatable(t, t1)
is(debug.getmetatable(t), t1)

local reg = debug.getregistry()
type_ok(reg, 'table', "function getregistry")
type_ok(reg._LOADED, 'table')

t = {}
function f () end
is(debug.setfenv(f, t), f, "function setfenv")
type_ok(debug.getfenv(f), 'table')
is(debug.getfenv(f), t)
is(debug.setfenv(print, t), print)
type_ok(debug.getfenv(print), 'table')
is(debug.getfenv(print), t)

t = {}
a = coroutine.create(function () return 1 end)
is(debug.setfenv(a, t), a, "function setfenv (thread)")
type_ok(debug.getfenv(a), 'table')
is(debug.getfenv(a), t)

error_like(function () t = {}; debug.setfenv(t, t) end,
           "'setfenv' cannot change environment of given object",
           "function setfenv (forbidden)")

t = {}
t1 = {}
is(debug.setmetatable(t, t1), true, "function setmetatable")
is(getmetatable(t), t1)

like(debug.traceback(), "^stack traceback:\n", "function traceback")

like(debug.traceback("message\n"), "^message\n\nstack traceback:\n", "function traceback with message")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
