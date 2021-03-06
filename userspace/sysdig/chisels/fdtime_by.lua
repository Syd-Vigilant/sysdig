--[[
Copyright (C) 2013-2018 Draios Inc dba Sysdig.

This file is part of sysdig.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--]]

-- Chisel description
description = "Groups FD activity based on the given filter field, and returns the keys where most time was spent. For example, this script can be used to list the processes or files that caused the biggest I/O latency."
short_description = "FD time group by"
category = "I/O"

-- Chisel argument list
args = 
{
	{
		name = "key", 
		description = "The filter field used for grouping", 
		argtype = "string"
	},
}

-- The number of items to show
TOP_NUMBER = 10
key_fld = ""

-- Argument notification callback
function on_set_arg(name, val)
	if name == "key" then
		key_fld = val
		return true
	end

	return false
end

-- Initialization callback
function on_init()
	chisel.exec("table_generator",
		key_fld, 
		key_fld,
		"evt.latency",
		"Time",
		"evt.is_io=true", 
		"" .. TOP_NUMBER,
		"time")
	return true
end
