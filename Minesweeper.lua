--Goto README. Created by Sambouza on Github
local mine_chance = 20/100
local grid_size = 10

local grid = {}

local function get_coord(coord)
	local letter = string.sub(coord, 1, 1)
	local number = tonumber(string.sub(coord, 2, 3))
	local mode = string.sub(coord, 4, 4)
	
	if mode == "" or mode == nil then
		mode = 1
	elseif mode == "f" then
		mode = 2
	else
		return nil
	end
	if letter < "a" or letter > "z" then
		return nil
	end
	if number < 1 or number > 26 then
		return nil
	end
	local position = string.byte(letter) - string.byte("a") + 1
	
	return position, number, mode
end
local function recursive_reveal()
	local stop_reveal = false
	while true do
		if stop_reveal == false then
			local control_grid = grid
			
			for i=1, grid_size do
				for j=1, grid_size do
					if grid[i][j].revealed == true then
						for k=1, grid_size do --to make sure everything is indexed?
							if grid[i-1] ~= nil and grid[i-1][j-1] ~= nil then --Top Left
								if grid[i-1][j-1].mine == false then
									grid[i-1][j-1].revealed = true
								end
							end
							if grid[i-1] ~= nil and grid[i-1][j] ~= nil then --Top
								if grid[i-1][j].mine == false then
									grid[i-1][j].revealed = true
								end
							end
							if grid[i-1] ~= nil and grid[i-1][j+1] ~= nil then --Top Right
								if grid[i-1][j+1].mine == false then
									grid[i-1][j+1].revealed = true
								end
							end
							if grid[i] ~= nil and grid[i][j-1] ~= nil then --Left
								if grid[i][j-1].mine == false then
									grid[i][j-1].revealed = true
								end
							end
							if grid[i] ~= nil and grid[i][j+1] ~= nil then --Right
								if grid[i][j+1].mine == false then
									grid[i][j+1].revealed = true
								end
							end
							if grid[i+1] ~= nil and grid[i+1][j-1] ~= nil then --Bottom Left
								if grid[i+1][j-1].mine == false then
									grid[i+1][j-1].revealed = true
								end
							end
							if grid[i+1] ~= nil and grid[i+1][j] ~= nil then --Bottom
								if grid[i+1][j].mine == false then
									grid[i+1][j].revealed = true
								end
							end
							if grid[i+1] ~= nil and grid[i+1][j+1] ~= nil then --Bottom Right
								if grid[i+1][j+1].mine == false then
									grid[i+1][j+1].revealed = true
								end
							end
						end
					end
				end
			end
			
			if control_grid == grid then
				stop_reveal = true
			end
		else
			break
		end
	end
end
local function calculate_neighbor_mines(row, col)
	local count = 0
	if grid[row-1] ~= nil and grid[row-1][col-1] ~= nil then --Top Left
		count = count + (grid[row-1
		][col-1].mine and 1 or 0)
	end
	if grid[row] ~= nil and grid[row][col-1] ~= nil then --Top
		count = count + (grid[row][col-1].mine and 1 or 0)
	end
	if grid[row+1] ~= nil and grid[row+1][col-1] ~= nil then --Top Right
		count = count + (grid[row+1][col-1].mine and 1 or 0)
	end
	if grid[row-1] ~= nil and grid[row-1][col] ~= nil then --Left
		count = count + (grid[row-1][col].mine and 1 or 0)
	end
	if grid[row+1] ~= nil and grid[row+1][col] ~= nil then --Right
		count = count + (grid[row+1][col].mine and 1 or 0)
	end
	if grid[row-1] ~= nil and grid[row-1][col+1] ~= nil then --Bottom Left
		count = count + (grid[row-1][col+1].mine and 1 or 0)
	end
	if grid[row] ~= nil and grid[row][col+1] ~= nil then --Bottom
		count = count + (grid[row][col+1].mine and 1 or 0)
	end
	if grid[row+1] ~= nil and grid[row+1][col+1] ~= nil then --Bottom Right
		count = count + (grid[row+1][col+1].mine and 1 or 0)
	end
	return count
end
local function get_color(number)
    if number == 1 then
        return "\27[38;5;39m"
    elseif number == 2 then
        return "\27[38;5;28m"
    elseif number == 3 then
        return "\27[38;5;196m"
    elseif number == 4 then
        return "\27[38;5;18m"
    elseif number == 5 then
        return "\27[38;5;88m"
    elseif number == 6 then
        return "\27[38;5;45m"
    elseif number == 7 then
        return "\27[38;5;236m"
    elseif number == 8 then
        return "\27[30m"
    else
        return ""
    end
end

--Manual
io.write("-Manual-\n", "\n-Created By Sambouza-\n")
io.write("-Controls-\n", "(selected row by letter, selected coloumn by number, selected mode by keyword) e.g.\n(a1) to select\n(e3 f) to flag.\n", "(b10f) to flag. no space if there's 2 digits.", "\n\n")
io.write("-Symbols-\n", "# - Unrevealed\n", "* - Revealed\n", "X - Mine\n", "! - Flagged\n", "% - Falsely Flagged")

--Grid creator
for i=1, grid_size do
	grid[i] = {}
	for j=1, grid_size do
		grid[i][j] = {revealed = false, flagged = false, mine = mine_chance > math.random() and true or false, neighbor_mines = 0}
	end
end

--Cell neighbor calculator
for i=1, grid_size do
	for j=1, grid_size do
		grid[i][j].neighbor_mines = calculate_neighbor_mines(i, j)
	end
end

local lost_game = false
while true do
	--[[
	--debug drawer
	for i=1, grid_size do
		for j=1, grid_size do
			io.write(grid[i][j].neighbor_mines, " ")
		end
		io.write("\n")
	end
	io.write("\n\n")
	for i=1, grid_size do
		for j=1, grid_size do
			if grid[i][j].mine == true then
				io.write("X ")
			else
				io.write("O ")
			end
		end
		io.write("\n")
	end
	io.write("\n\n")
	--]]
	
	--Drawer
	io.write("\n\n\n")
	for i=1, grid_size+2 do
		if i == grid_size+2 then
			io.write("    ")
			for j=1, grid_size do
				io.write(j, " ")
			end
		elseif i == grid_size+1 then
			io.write("    ")
			for j=1, grid_size do
				io.write("_ ")
			end
		else
			io.write(string.char(i+96), " | ")
			for j=1, grid_size do
				if lost_game == true then
					if grid[i][j].mine == true then
						if grid[i][j].flagged == true then
							io.write("\27[38;5;196m!\27[0m ")
						else
							io.write("\27[31mX\27[0m ")
						end
					else 
						if grid[i][j].flagged == true then 
							io.write("\27[38;5;196m%\27[0m ")
						else 
							io.write("\27[37m#\27[0m ") 
						end 
					end  
				else 
					if grid[i][j].revealed == true then 
						if grid[i][j].flagged == true then 
							io.write("\27[38;5;208m!\27[0m ") 
						else 
							if grid[i][j].neighbor_mines == 0 and grid[i][j].mine == false then 
								io.write("\27[37m*\27[0m ") 
							else 
								io.write(get_color(grid[i][j].neighbor_mines), grid[i][j].neighbor_mines, "\27[0m ") 
							end 
						end 
					else 
						if grid[i][j].flagged == true then 
							io.write("\27[38;5;208m!\27[0m ") 
						else 
							io.write("\27[38;5;240m#\27[0m ") 
						end 
					end 
				end
			end
		end
		io.write("\n")
	end
	
	--If Lost End
	if lost_game == true then
		break
	end
	--Win State Handler
	local win_game = true
	for i=1, grid_size do
		for j=1, grid_size do
			 if grid[i][j].mine == true and grid[i][j].flagged == false then
				win_game = false
			 end
			 if grid[i][j].mine == false and grid[i][j].revealed == false then
				win_game = false
			 end
		end
	end
	if win_game == true then
		io.write("\n----\nCongratulations! You Win Minesweeper! B)\n----\n")
		break
	end
	
	--Input handler
	local selected_row = nil
	local selected_col = nil
	local selected_mode = nil
	while true do
		io.write("Select cell (e.g. a1, e4 f)\n")
		selected_row, selected_col, selected_mode = get_coord(io.read("*line"))
		
		if selected_row == nil or selected_col == nil or selected_mode == nil then
			io.write("Invalid input, try again.\n")
		else
			break
		end
	end
	local selected_cell = grid[selected_row][selected_col]
	if selected_mode == 1 then
		if selected_cell.flagged ~= true then
			selected_cell.revealed = true
		end
	elseif selected_mode == 2 then
		if selected_cell.flagged == true then
			selected_cell.flagged = false
		else
			selected_cell.flagged = true
		end
	end
	
	--Recursive cell reveal
	recursive_reveal()
	
	--Lost State Handler
	for i=1, grid_size do
		for j=1, grid_size do
			if grid[i][j].mine == true and grid[i][j].revealed == true then
				lost_game = true
			end
		end
	end
	if lost_game == true then
		io.write("\nYou lose!\n")
	end
end