--[[
    Easy Downgrader/Updater for PS Vita designed By:
	- BaltazaR4 (https://twitter.com/baltazarregala4).
	with help from:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

color.loadpalette()
back = image.load("resources/back.png")	
back1 = image.load("resources/back1.png")	
version = os.swversion()

--Update
dofile("git/shared.lua")
dofile("git/updater.lua")

dofile("lang/english_us.txt")
if files.exists("lang/"..os.language()..".txt") then dofile("lang/"..os.language()..".txt") end

function warning(img)
	img:blit(0,0)
		screen.print(480,15,STRINGS_WARNING_TITLE,1.2,color.white,0x0,__ACENTER)
		screen.print(480,185,STRINGS_FIRST_WARNING_1,1.2,color.white,0x0,__ACENTER)
		screen.print(480,215,STRINGS_FIRST_WARNING_2,1.2,color.white,0x0,__ACENTER)
		screen.print(480,245,STRINGS_FIRST_WARNING_3,1.2,color.white,0x0,__ACENTER)
		screen.print(480,275,STRINGS_FIRST_WARNING_4,1.2,color.white,0x0,__ACENTER)
		screen.print(480,305,STRINGS_FIRST_WARNING_5,1.2,color.white,0x0,__ACENTER)
		screen.print(10,520,STRINGS_WARNING,1,color.green)
	screen.flip()
	buttons.waitforkey()
end

function warning2(img)
	img:blit(0,0)
		screen.print(480,15,STRINGS_WARNING_TITLE,1.2,color.white,0x0,__ACENTER)
		screen.print(480,185,STRINGS_SECOND_WARNING_1,1.2,color.white,0x0,__ACENTER)
		screen.print(480,215,STRINGS_SECOND_WARNING_2,1.2,color.white,0x0,__ACENTER)
		screen.print(480,245,STRINGS_SECOND_WARNING_3,1.2,color.white,0x0,__ACENTER)
		screen.print(10,520,STRINGS_WARNING,1,color.green)
	screen.flip()
	buttons.waitforkey()
end

warning(back1)
warning2(back1)

dofile("system/functions.lua")
dofile("system/callbacks.lua")

-----------------Menu---------------------

while true do
    buttons.read()
    if back then back:blit(0,0) end

    ---------------------------Impresion en pantalla-----------------------------------

    if version == "3.65" then
	    screen.print(10,10,STRINGS_TITLE1,1,color.white)
	else
        screen.print(10,10,STRINGS_TITLE2,1,color.white)
		screen.print(740,490,STRINGS_VERSION..tostring(os.swversion()))
    end

	screen.print(10,490,STRINGS_WLAN..tostring(wlan.strength()).."%")

    screen.print(400,410,STRINGS_INSTALL_HE,1,color.white,color.black)

    screen.print(160,260,STRINGS_INSTALL_EN,1,color.white,color.black)

    screen.print(410,120,STRINGS_INSTALL_MO,1,color.white,color.black)

	screen.print(620,260,STRINGS_DOWNLOAD_P,1,color.green,color.black)

	screen.print(360,520,STRINGS_EXTRA_OPTS,1,color.green)

	if files.exists("ux0:app/PCSG90096") then
	    screen.print(950,10,STRINGS_H_FOUND,1,color.green,0x0,__ARIGHT)
	else
        screen.print(950,10,STRINGS_H_NOTF,1,color.green,0x0,__ARIGHT)	
	end

	--if buttons.select then error("FTP") end
	menu_ctx.run()

	screen.flip()

	----------------------------------Controles de homebrew-------------------------------

	--Submenu no Abierto
	if not menu_ctx.open then

		if buttons.circle then
			menu_pups()
			pup_download = ""
		end

		if buttons.cross then
			if not game.exists("PCSG90096") then 
				hm_core(HENCORE)
			else
			    hen_shrink()
			end
		end

		if buttons.square then
			menu_enso()
		end

		if buttons.triangle then
			if game.exists("MODORU000") and game.rif("MODORU000") then
				os.message(STRINGS_MODO_FOUND,0) 
			else
				modoru()
			end
		end

	--Submenu Abierto
	else

		if buttons.cross then
			if version >= "3.65" then 
		        os.message(STRINGS_REST_MEINS,0)
			elseif version <= "3.63" then 
				if not game.exists("PCSG90096") then 
					hm_core(MEMECORE)
                else
                    hen_shrink()				
                end				
		    end
		end

		if buttons.held.l and buttons.up then
			if game.exists("PCSG90096") then
			    if version >= "3.65" then
				    os.message(STRINGS_REST_MEREI,0)
			    elseif version <= "3.63" then
				    os.message(STRINGS_MERE_SAVE,0)
				    savedata_core(MEMECORE)
				    power.restart()
				end	
			else
				os.message(STRINGS_ME_NOBUB,0)
			end
		end

		if buttons.held.r and buttons.up then
			if game.exists("PCSG90096") then
				os.message(STRINGS_HERE_SAVE,0)
				savedata_core(HENCORE)
				power.restart()
			else
				os.message(STRINGS_HE_NOBUB,0)
			end
		end

	end

end
