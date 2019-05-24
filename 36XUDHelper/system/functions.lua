--[[
    Easy Downgrader/Updater for PS Vita designed By:
	- BaltazaR4 (https://twitter.com/baltazarregala4).
	with help from:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

--For Decrypting (from vitashell)
if files.exists("modules/kernel.skprx") then
	if os.requirek("modules/kernel.skprx")==1 then __kernel = true end
else
	if os.requirek("ux0:VitaShell/module/kernel.skprx")==1 then	__kernel = true end
end

if files.exists("modules/user.suprx") then
	if os.requireu("modules/user.suprx")==1 then __user = true end
else
	if os.requireu("ux0:VitaShell/module/user.suprx")==1 then __user = true end
end

SYMBOL_CIRCLE	= string.char(0xe2)..string.char(0x97)..string.char(0x8b)
SYMBOL_CROSS	= string.char(0xe2)..string.char(0x95)..string.char(0xb3)

BCANCEL = SYMBOL_CIRCLE
if buttons.assign()==0 then BCANCEL = SYMBOL_CROSS end

function message_wait(message)
	local mge = (message or STRINGS_WAIT)
	local titlew = string.format(mge)
	local w,h = screen.textwidth(titlew,1) + 30,70
	local x,y = 480 - (w/2), 272 - (h/2)

	draw.fillrect(x,y,w,h, color.shine)
	draw.rect(x,y,w,h,color.white)
		screen.print(480,y+15, titlew,1,color.white,color.black,__ACENTER)
	screen.flip()
end

HENCORE =  "resources/h-core/PCSG90096"
MEMECORE = "resources/m-core/PCSG90096"

function personalize_savedata(path)
    local fd = io.open(path, "r+");
	if fd then
		fd:seek("set", 0xe4);
		fd:write(os.getreg("/CONFIG/NP", "account_id", 3, 8));
		fd:close();
		return true;
	end
	return false;
end

function savedata_core(path)
    if files.exists("ux0:user/00/savedata/PCSG90096") then files.delete("ux0:user/00/savedata/PCSG90096") end
	files.copy(path, "ux0:user/00/savedata/")

	game.umount()
		game.mount("ux0:user/00/savedata/PCSG90096")
		--os.savedata("ux0:user/00/savedata/PCSG90096/sce_sys/param.sfo")
		personalize_savedata("ux0:user/00/savedata/PCSG90096/sce_sys/param.sfo")
	game.umount()
end

function hm_core(path)
    if back1 then back1:blit(0,0) end
		
	buttons.homepopup(0)

		files.copy("resources/encore/app/PCSG90096", "ux0:app")
		local result = game.refresh("ux0:app/PCSG90096")
		if result == 1 then
			files.copy("resources/encore/appmeta/PCSG90096", "ux0:appmeta")

			if back1 then back1:blit(0,0) end
				message_wait(STRINGS_CUSTOM_SAVEDATA)
			os.delay(750)
			savedata_core(path)

			os.message(STRINGS_REBOOT)	
			os.delay(150)
			os.updatedb()
			if back1 then back1:blit(0,0) end
				message_wait()
			os.delay(750)
			power.restart()
		else
			os.message(STRINGS_ERROR)
		end

	buttons.homepopup(1)
end

function core()
    if back1 then back1:blit(0,0) end
		message_wait(STRINGS_BUB_SHRINK)
	os.delay(500)

	buttons.homepopup(0)

	    files.delete("ux0:app/PCSG90096/")
		files.copy("resources/encore/app/PCSG90096", "ux0:app")
		os.message(STRINGS_S_DONE)

	buttons.homepopup(1)
end

function hen_shrink()
	if files.size("resources/encore/app/PCSG90096") < files.size("ux0:app/PCSG90096") then
		if os.message(STRINGS_SHRINK,1) == 1 then
			core()
		end
	else
		os.message(STRINGS_MEHE_FOUND,0)
	end
end

function modoru()
    if back1 then back1:blit(0,0) end
		
	buttons.homepopup(0)

		files.copy("resources/modoru/MODORU000", "ux0:app")
		local result = game.refresh("ux0:app/MODORU000")
		if result == 1 then
			os.message(STRINGS_MODORU)
		else
			os.message(STRINGS_ERROR)
		end

	buttons.homepopup(1)
end

pups = {
	{ name = "3.60 UPDATE", name2 = "360_PSP2UPDAT.PUP", link = "http://www.mediafire.com/file/pu0ld9au549s9mb/360_PSP2UPDAT.PUP/file",	crc = 0xA0A98D12,  },
	{ name = "3.65 UPDATE", name2 = "365_PSP2UPDAT.PUP", link = "http://www.mediafire.com/file/qz4h7ptp2tztx5f/365_PSP2UPDAT.PUP/file",	crc = 0xE13A9791,  },
	{ name = "3.68 UPDATE", name2 = "368_PSP2UPDAT.PUP", link = "http://www.mediafire.com/file/j0st3bbu1f2c6k7/368_PSP2UPDAT.PUP/file",	crc = 0x275FBDF6,  },
	--{ name = "3.70 UPDATE", name2 = "370_PSP2UPDAT.PUP", link = "http://www.mediafire.com/file/1e5dah4j31zlghc/370_PSP2UPDAT.PUP/file",	crc = 0x3FB0848A,  },
}

function dl_file(obj)

	if not game.exists("MODORU000") then
		os.message(STRINGS_MODO_NOT_FOUND)
		modoru()
	end

	if not game.exists("MODORU000") then os.message(STRINGS_MODO_PROBLEM) return false end

	CRC = ""
	pup_download = ""
	
	if files.exists("ux0:app/MODORU000/PSP2UPDAT.PUP") then

		if back1 then back1:blit(0,0) end
			message_wait(STRINGS_PUP_DETECT)
		os.delay(500)

		CRC = files.crc32("ux0:app/MODORU000/PSP2UPDAT.PUP")

		if CRC == obj.crc then
			os.message(obj.name2.."\n\n"..STRINGS_PUP_RIGHT)
			return true
		else

			if files.exists("ux0:data/PUPS/"..obj.name2) then
				files.delete("ux0:app/MODORU000/PSP2UPDAT.PUP")
				files.copy("ux0:data/PUPS/"..obj.name2, "ux0:app/MODORU000/")
				files.rename("ux0:app/MODORU000/"..obj.name2, "PSP2UPDAT.PUP")
				os.message(obj.name2.."\n\n"..STRINGS_PUP_RIGHT)
				return true
			end
		end

	else

		if files.exists("ux0:data/PUPS/"..obj.name2) then
			files.copy("ux0:data/PUPS/"..obj.name2, "ux0:app/MODORU000/")
			files.rename("ux0:app/MODORU000/"..obj.name2, "PSP2UPDAT.PUP")
			os.message(obj.name2.."\n\n"..STRINGS_PUP_RIGHT)
			return true
		end

	end

	if back1 then back1:blit(0,0) end
		message_wait(STRINGS_WAIT_DL)
	os.delay(500)

	buttons.homepopup(0)
	if http.download(obj.link,"mf.html").success then
		local objh = html.parsefile("mf.html")
		if objh then
			local var = objh:find(html.TAG_A, html.ATTR_CLASS, "input")
			if var.raw then

				pup_download = obj.name
				if http.download(var.href, "ux0:data/PUPS/"..obj.name2).success then
	
					if back1 then back1:blit(0,0) end
						message_wait(obj.name2..STRINGS_PUP_CRC)
					os.delay(500)

					if files.crc32("ux0:data/PUPS/"..obj.name2) == obj.crc then
						files.delete("ux0:app/MODORU000/PSP2UPDAT.PUP")
						files.copy("ux0:data/PUPS/"..obj.name2, "ux0:app/MODORU000/")
						files.rename("ux0:app/MODORU000/"..obj.name2, "PSP2UPDAT.PUP")
						os.message(obj.name.."\n\n"..STRINGS_PUP_MOVED)
						buttons.homepopup(1)
						return true
					else
						os.message(STRINGS_PUP_CORPTD)
						files.delete("ux0:data/PUPS/"..obj.name2)
					end
				else
					files.delete("ux0:data/PUPS/"..obj.name2)
					os.message(STRINGS_DL_ERROR)
				end

			else os.message(STRINGS_DL_ERROR) end

		else
			os.message(STRINGS_PARSE_ERR)
		end

	else
		os.message(STRINGS_DL_HTML)
	end

	buttons.homepopup(1)
	return false
    
end

function menu_pups()

	local selector = 1
	buttons.interval(12,6)
	while true do
		buttons.read()

		if back1 then back1:blit(0,0) end
		screen.print(480,10,STRINGS_PUPS_SEL,1.0,color.white,color.gray,__ACENTER)

		local y = 180
		for i=1, #pups do
			if i == selector then
				draw.fillrect(0,y-5,960,29,color.green:a(100))
			end
			screen.print(480,y,pups[i].name,1.0,color.white,color.gray,__ACENTER)
			y+=30
		end

		screen.flip()

		--Controls
		if buttons.up then
			selector -= 1
		end
		if buttons.down then
			selector += 1
		end

		if selector < 1 then selector = #pups end
		if selector > #pups then selector = 1 end

		if buttons.cancel then return end

		if buttons.accept then
			if back1 then back1:blit(0,0) end
				message_wait()
			os.delay(500)
			if dl_file(pups[selector]) then return end
		end

	end

end

Ensos = { 
	{	name = "3.60 Enso v1.1", path = "resources/360enso/MLCL00003",	crc = 0x2BC26A81 },
	{	name = "3.65 Enso v1.1", path = "resources/enso/MLCL00003",		crc = 0xD6FE3C33 },
}

function install_enso(obj)
    if back1 then back1:blit(0,0) end

	CRC = ""
	buttons.homepopup(0)

		if game.exists("MLCL00003") then

			if back1 then back1:blit(0,0) end
				message_wait(STRINGS_ENSO_DETECT)
			os.delay(500)

			CRC = files.crc32("ux0:app/MLCL00003/EBOOT.BIN")

			local flag = false
			for i=1,#Ensos do
				
				if CRC == Ensos[i].crc then
					flag = true
					if Ensos[i].crc == obj.crc then
						os.message(Ensos[i].name.."\n\n"..STRINGS_ENSO_FOUND)
						buttons.homepopup(1)
						return true
					end
				end
			end
			game.delete("MLCL00003")
		end

		if back1 then back1:blit(0,0) end
			message_wait()
		os.delay(500)

		files.copy(obj.path, "ux0:app")
		local result = game.refresh("ux0:app/MLCL00003")
		if result == 1 then
			os.message(obj.name.."\n\n"..STRINGS_ENSO)
			buttons.homepopup(1)
			return true
		else
			os.message(STRINGS_ERROR)
		end

	buttons.homepopup(1)
	return false
end

function menu_enso()

	local selector = 1
	buttons.interval(12,6)
	while true do
		buttons.read()

		if back1 then back1:blit(0,0) end
		screen.print(480,10,STRINGS_ENSO_SEL,1.0,color.white,color.gray,__ACENTER)

		local y = 180
		for i=1, #Ensos do
			if i == selector then
				draw.fillrect(0,y-5,960,29,color.green:a(100))
			end
			screen.print(480,y,Ensos[i].name,1.0,color.white,color.gray,__ACENTER)
			y+=30
		end

		screen.flip()

		--Controls
		if buttons.up then
			selector -= 1
		end
		if buttons.down then
			selector += 1
		end

		if selector < 1 then selector = #Ensos end
		if selector > #Ensos then selector = 1 end
		
		if buttons.released.cancel then return true end
		
		if buttons.accept then
			if back1 then back1:blit(0,0) end
				message_wait()
			os.delay(500)
			if install_enso(Ensos[selector]) then return true end
		end

	end

end

---------comienzo de ctx menu-----------------------
	
menu_ctx = { -- Creamos un objeto menu contextual
    h = 272,				-- Height of menu
    w = 960,				-- Width of menu
    x = 0,				    -- X origin of menu
    y = -272,				-- Y origin of menu
    open = false,			-- Is the menu open?
    close = true,
    speed = 10,				-- Effect speed if Open/Close.
    ctrl = "select",
}

function menu_ctx.run()
	if buttons[menu_ctx.ctrl] then
		menu_ctx.close = not menu_ctx.close
	end
	
	--if menu_ctx.open then
		menu_ctx.draw()
		menu_ctx.buttons()
	--end

end

function menu_ctx.draw()

    if not menu_ctx.close and menu_ctx.y < 0 then
        menu_ctx.y += menu_ctx.speed
    elseif menu_ctx.close and menu_ctx.y > -menu_ctx.h then
        menu_ctx.y -= menu_ctx.speed
    end

	if menu_ctx.y > -menu_ctx.h then
		draw.fillrect(menu_ctx.x, menu_ctx.y, menu_ctx.w, menu_ctx.h, color.new(100,0,255,170))
		draw.fillrect(menu_ctx.x, menu_ctx.y, menu_ctx.w, menu_ctx.h, color.new(0,0,0,120))
	end

    if menu_ctx.y >= 0 then
        menu_ctx.open = true 		
		    screen.print(20,10,STRINGS_EXTRA_T,1,color.green)
			screen.print(950,10,STRINGS_EXTRA_C,1,color.green,0x0,__ARIGHT)
		    screen.print(250,90,STRINGS_EXTRA_MEME,1,color.green,color.black)
		    screen.print(250,150,STRINGS_EXTRA_HERE,1,color.white,color.black)
			screen.print(250,220,STRINGS_EXTRA_MERE,1,color.white,color.black)
    else
        menu_ctx.open = false
    end
end

function menu_ctx.buttons()
	if not menu_ctx.open then return end


	if buttons.select then -- Run function of cancel option.
		menu_ctx.close = not menu_ctx.close
	end
end

