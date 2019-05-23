--[[
    Easy Downgrader/Updater for PS Vita designed By:
	- BaltazaR4 (https://twitter.com/baltazarregala4).
	with help from:
	- Gdljjrod (https://twitter.com/gdljjrod).
]]

function onCopyFiles(size,written,file)
    if back1 then back1:blit(0,0) end
	draw.fillrect(0,0,960,30, color.green:a(75))
	
	screen.print(10,10,STRINGS_INSTALL)
	screen.print(10,40,STRINGS_FILE..tostring(file))
	--screen.print(10,50,"Percent: "..math.floor((written*100)/size).." %")

	l = (written*940)/size
		screen.print(3+l,495,math.floor((written*100)/size).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
			draw.fillrect(10,524,l,6,color.new(0,255,0))
				draw.circle(10+l,526,6,color.new(0,255,0),30)

	screen.flip()
	return 1
end

pup_download = ""
function onNetGetFile(size,written,speed)
	power.tick(0)
	if update then update:blit(0,0)
	elseif back1 then back1:blit(0,0) end

	screen.print(10,10,pup_download)--STRINGS_DLOAD)
	screen.print(480,470,tostring(files.sizeformat(written or 0)).." / "..tostring(files.sizeformat(size or 0)),1,color.white, color.blue:a(135),__ACENTER)
	screen.print(480,50,STRINGS_CANCEL.." "..BCANCEL,1,color.white, color.blue:a(135),__ACENTER)
	
	l = (written*940)/size
		screen.print(3+l,495,math.floor((written*100)/size).."%",0.8,0xFFFFFFFF,0x0,__ACENTER)
			draw.fillrect(10,524,l,6,color.new(0,255,0))
				draw.circle(10+l,526,6,color.new(0,255,0),30)

	screen.flip()

	buttons.read()
	if buttons.cancel then return 0 end --Cancel or Abort
	return 1

end
