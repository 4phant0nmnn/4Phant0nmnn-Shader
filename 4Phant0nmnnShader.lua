if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local gfx = {
	hora = 16.6,
	latitud = 35,
	brillo = 2.1,
	exposicion = -0.1,
	ambiente = Color3.fromRGB(82, 78, 74),
	ambienteExterior = Color3.fromRGB(128, 122, 116),
	sombraSuavidad = 0.12,
	cieloClaro = false,
	quitarNiebla = true,
	nubes = false,
	atmDensidad = 0.33,
	atmOffset = 0.12,
	atmHaze = 1.5,
	atmGlare = 1.1,
	atmColor = Color3.fromRGB(170, 163, 152),
	atmDecay = Color3.fromRGB(96, 84, 74),
	nieblaCercana = 0.12,
	saturacion = 0.5,
	contraste = 0.24,
	brilloColor = -0.04,
	tinte = Color3.fromRGB(255, 252, 248),
	bloomIntensidad = 0.35,
	bloomTamano = 28,
	bloomUmbral = 1.25,
	rayosIntensidad = 0.1,
	rayosAlcance = 1,
	lejosBorroso = true,
	lejosIntensidad = 0.32,
	lejosFoco = 45,
	lejosRadio = 55,
	cercaIntensidad = 0,
	polvo = true,
	polvoCantidad = 90,
	destellosCantidad = 18,
	arenaCantidad = 8,
	polvoColor = Color3.fromRGB(255, 236, 205),
	vineta = true,
	vinetaFuerza = 0.45,
	aguaReflejo = true,
	pisosBrillantes = true,
	pisoReflectance = 0.3,
	pisoMojado = true,
	mojadoReflectance = 0.45,
	mojadoOscurecer = 0.18,
	mojadoBarniz = 0.5,
	pisoVidrio = true,
	vidrioColor = Color3.fromRGB(215, 235, 255),
	vidrioTransparencia = 0.55,
	vidrioReflectance = 0.6,
	vidrioMax = 1500,
	pisoMaterial = nil,
	pisoPulir = true,
	pisoLadoMinimo = 16,
	superficiesBrillantes = true,
	paredReflectance = 0.22,
	texturaTransparenciaMin = 0,
	reflejoNitidez = 0.35, -- 1 = espejo, 0.35 = reflejo difuminado
	barniz = true,
	barnizFuerza = 0.35,
	barnizMax = 4000,
	lluvia = false,
	lluviaIntensidad = 2200,
	lluviaSalpicaduras = 320,
	lluviaViento = 8,
	lluviaVelocidad = 115,
	lluviaEstirar = 2.4,
	lluviaOscurecer = 0.45,
	lluviaCerca = 900,
	lluviaLente = true,
	lluviaNeblinaSuelo = 6,
	tormentaEscombros = 14,
	pastoViento = true,
	pastoFuerza = 1,
	pastoNombres = { "grass", "pasto", "hierba", "cesped", "césped", "plant", "planta", "bush", "arbusto",
		"leaf", "leaves", "hoja", "flower", "flor", "weed", "fern", "helecho", "reed", "junco", "shrub", "foliage" },
	relampagos = true,
	tormenta = false,
	tormentaRayosMin = 2,
	tormentaRayosMax = 7,
	tormentaATierra = 0.45,
	tormentaRafagas = 0.7,
	tormentaCortinas = 6,
	tormentaTemblor = true,
	truenoSonido = "",
	lluviaSonido = "",
	noche = false,
	nocheHora = 0.5,
	nocheLuna = 2.2,
	nocheExposicion = 0.8,
	nocheEstrellas = 4000,
	nocheAmbiente = Color3.fromRGB(72, 80, 104),
	nocheExterior = Color3.fromRGB(112, 124, 158),
	nocheTinte = Color3.fromRGB(205, 218, 255),
	linterna = false,
	luzJugador = true,
	aurora = false,
	auroraIntensidad = 1,
	auroraVelocidad = 1,
	auroraRojo = 0.5,
	auroraSubtormentas = true,
	auroraFugaces = true,
	auroraEscarcha = true,
	auroraBandas = true,
	auroraRayos = 0.55,
	destelloSol = true,
	destelloFuerza = 0.8,
	luciernagas = 0,
	nieblaBaja = 0,
	nieblaBajaColor = Color3.fromRGB(200, 205, 215),
	remolinos = false,
	brisa = 0.3,
	solRealista = false,
	solBrillo = 1,
	solTamano = 1,
	skybox = "",
	skyLuz = true,
	skyLuzFuerza = 0.8,
	skySolAlinear = true,
	rellenoSombra = 0.45,
	skyGiro = 0,
	skyVelocidad = 0,
}

local function efecto(clase, nombre)
	local e = Lighting:FindFirstChild(nombre)
	if not e or not e:IsA(clase) then
		e = Instance.new(clase)
		e.Name = nombre
		e.Parent = Lighting
	end
	return e
end

local cieloPropio
local cielosQuitados = {}
-- cielos (skybox) que se pueden poner desde el panel
local function cieloDe(bk, dn, ft, lf, rt, up)
	local r = "rbxassetid://"
	return {
		SkyboxBk = r .. bk, SkyboxDn = r .. dn, SkyboxFt = r .. ft, SkyboxLf = r .. lf, SkyboxRt = r .. rt, SkyboxUp = r .. up,
		SunTextureId = "rbxasset://sky/sun.jpg", MoonTextureId = "rbxasset://sky/moon.jpg",
		SunAngularSize = 21, MoonAngularSize = 11, StarCount = 0, CelestialBodiesShown = false,
	}
end
local SKYBOXES = {
	lista = {
		{ "Clockwork Clouds", {
			SkyboxBk = "rbxassetid://134612281360909", SkyboxDn = "rbxassetid://135894200466484",
			SkyboxFt = "rbxassetid://136874646410117", SkyboxLf = "rbxassetid://114475776830763",
			SkyboxRt = "rbxassetid://84451061100634", SkyboxUp = "rbxassetid://122947185124235",
			SunTextureId = "rbxasset://sky/sun.jpg", MoonTextureId = "rbxasset://sky/moon.jpg",
			SunAngularSize = 21, MoonAngularSize = 11, StarCount = 0, CelestialBodiesShown = false,
		}, { exterior = Color3.fromRGB(141, 154, 168), ambiente = Color3.fromRGB(98, 107, 115), atm = Color3.fromRGB(190, 207, 224), decay = Color3.fromRGB(88, 98, 107), tinte = Color3.fromRGB(238, 247, 255), sol = Color3.fromRGB(166, 179, 191), oscuro = false } },
		{ "Purple Void", cieloDe("76189443644255", "96142650793045", "84132497276297", "117008061366919", "74203136036040", "92209632503067"), { exterior = Color3.fromRGB(138, 124, 168), ambiente = Color3.fromRGB(97, 89, 115), atm = Color3.fromRGB(187, 169, 224), decay = Color3.fromRGB(87, 77, 107), tinte = Color3.fromRGB(237, 228, 255), sol = Color3.fromRGB(164, 151, 191), oscuro = false } },
		{ "Blue", cieloDe("101937755786830", "130985965387874", "110158710601688", "134311061582349", "100841709986852", "95350315324970"), { exterior = Color3.fromRGB(100, 138, 168), ambiente = Color3.fromRGB(75, 97, 115), atm = Color3.fromRGB(140, 187, 224), decay = Color3.fromRGB(61, 87, 107), tinte = Color3.fromRGB(214, 237, 255), sol = Color3.fromRGB(129, 164, 191), oscuro = false } },
		{ "Bubble Teal", cieloDe("103784264754996", "139141519550802", "118643650939963", "136258763574121", "80164222293306", "88580337131022"), { exterior = Color3.fromRGB(115, 168, 165), ambiente = Color3.fromRGB(83, 115, 113), atm = Color3.fromRGB(158, 224, 220), decay = Color3.fromRGB(71, 107, 105), tinte = Color3.fromRGB(223, 255, 253), sol = Color3.fromRGB(143, 191, 188), oscuro = false } },
		{ "Chill Pink", cieloDe("118207520625284", "132439873953469", "102565262398046", "138607277545109", "89305520196648", "89380866939918"), { exterior = Color3.fromRGB(124, 123, 168), ambiente = Color3.fromRGB(88, 88, 115), atm = Color3.fromRGB(169, 168, 224), decay = Color3.fromRGB(77, 76, 107), tinte = Color3.fromRGB(228, 228, 255), sol = Color3.fromRGB(151, 150, 191), solDir = Vector3.new(0.86, 0.26, -0.41).Unit, oscuro = false } },
		{ "Light Pink", cieloDe("134610223843606", "99176787657552", "130401681744482", "116731322701868", "123992597745152", "90316603987910"), { exterior = Color3.fromRGB(168, 119, 164), ambiente = Color3.fromRGB(115, 86, 112), atm = Color3.fromRGB(224, 163, 218), decay = Color3.fromRGB(107, 74, 104), tinte = Color3.fromRGB(255, 225, 252), sol = Color3.fromRGB(191, 146, 187), oscuro = false } },
		{ "Sky Purple", cieloDe("136903708404751", "83734550505833", "138640842447004", "124880918329631", "125180772550409", "110413612365796"), { exterior = Color3.fromRGB(130, 83, 168), ambiente = Color3.fromRGB(92, 64, 115), atm = Color3.fromRGB(176, 118, 224), decay = Color3.fromRGB(81, 49, 107), tinte = Color3.fromRGB(232, 203, 255), sol = Color3.fromRGB(156, 114, 191), oscuro = false } },
		{ "Pandora", cieloDe("81215226297854", "107109344200675", "115258412499326", "73866850728908", "85447371250658", "107637292032155"), { exterior = Color3.fromRGB(78, 115, 168), ambiente = Color3.fromRGB(62, 83, 115), atm = Color3.fromRGB(112, 158, 224), decay = Color3.fromRGB(46, 71, 107), tinte = Color3.fromRGB(200, 223, 255), sol = Color3.fromRGB(109, 143, 191), oscuro = false } },
		{ "Nibiru", cieloDe("111622903331601", "96354815314390", "103439563595693", "102190380697376", "86129077796631", "103578350036393"), { exterior = Color3.fromRGB(107, 120, 168), ambiente = Color3.fromRGB(78, 86, 115), atm = Color3.fromRGB(148, 165, 224), decay = Color3.fromRGB(65, 74, 107), tinte = Color3.fromRGB(218, 226, 255), sol = Color3.fromRGB(135, 148, 191), oscuro = false } },
		{ "Red Koi", cieloDe("92226175200599", "93840303299017", "128498520668411", "106005046918569", "101537261452294", "76078291698654"), { exterior = Color3.fromRGB(128, 56, 70), ambiente = Color3.fromRGB(92, 47, 56), atm = Color3.fromRGB(158, 75, 92), decay = Color3.fromRGB(71, 29, 37), tinte = Color3.fromRGB(255, 198, 209), sol = Color3.fromRGB(191, 105, 122), oscuro = true } },
		{ "Jungle", cieloDe("102004275178236", "99647411295322", "138350852957040", "74854810425956", "76675655580150", "125406593271521"), { exterior = Color3.fromRGB(149, 168, 168), ambiente = Color3.fromRGB(103, 115, 114), atm = Color3.fromRGB(200, 224, 224), decay = Color3.fromRGB(94, 107, 107), tinte = Color3.fromRGB(243, 255, 255), sol = Color3.fromRGB(173, 191, 191), solDir = Vector3.new(0.18, 0.68, 0.71).Unit, oscuro = false } },
		{ "Goodnight", cieloDe("82662248441949", "139069019327721", "115741273850066", "72294087335015", "106919946212558", "129371947089664"), { exterior = Color3.fromRGB(67, 68, 128), ambiente = Color3.fromRGB(54, 55, 92), atm = Color3.fromRGB(88, 89, 158), decay = Color3.fromRGB(35, 36, 71), tinte = Color3.fromRGB(207, 207, 255), sol = Color3.fromRGB(119, 120, 191), oscuro = true } },
		{ "Grimnight", cieloDe("104821965438126", "79186197906324", "73831593397359", "77344512896160", "135714991859147", "93438266192657"), { exterior = Color3.fromRGB(103, 116, 128), ambiente = Color3.fromRGB(77, 84, 92), atm = Color3.fromRGB(130, 144, 158), decay = Color3.fromRGB(57, 64, 71), tinte = Color3.fromRGB(236, 246, 255), sol = Color3.fromRGB(162, 177, 191), oscuro = true } },
	},
	actual = nil,
}
SKYBOXES.solCache = {}
-- busca la hora y latitud con las que el sol de Roblox queda donde está el sol pintado del cielo
function SKYBOXES.resolverSol(dir)
	local mejor, mt, ml = -2, Lighting.ClockTime, Lighting.GeographicLatitude
	local function probar(t, l)
		Lighting.ClockTime = t
		Lighting.GeographicLatitude = l
		local d = Lighting:GetSunDirection():Dot(dir)
		if d > mejor then mejor, mt, ml = d, t, l end
	end
	for t = 5, 19, 0.5 do
		for l = -80, 80, 5 do probar(t, l) end
	end
	local t0, l0 = mt, ml
	for t = t0 - 0.5, t0 + 0.5, 0.05 do
		for l = l0 - 5, l0 + 5, 0.5 do probar(t, l) end
	end
	return mt, ml
end
function SKYBOXES.buscar(nombre)
	for _, c in ipairs(SKYBOXES.lista) do
		if c[1] == nombre then return c end
	end
end
local aplicando = false

-- cómo estaba el mapa antes del shader, para poder apagarlo con una tecla
local sinShader = { activo = false, luz = {}, efectos = {}, apagados = {} }
do
	for _, prop in ipairs({ "ClockTime", "GeographicLatitude", "Brightness", "ExposureCompensation", "Ambient", "OutdoorAmbient",
		"GlobalShadows", "FogStart", "FogEnd", "FogColor", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "ShadowSoftness", "ColorShift_Top" }) do
		pcall(function() sinShader.luz[prop] = Lighting[prop] end)
	end
	for _, e in ipairs(Lighting:GetChildren()) do
		if e:IsA("PostEffect") then sinShader.efectos[e] = e.Enabled end
	end
	local atm = Lighting:FindFirstChildOfClass("Atmosphere")
	if atm then
		sinShader.atm = atm
		sinShader.atmProps = { Density = atm.Density, Offset = atm.Offset, Haze = atm.Haze, Glare = atm.Glare, Color = atm.Color, Decay = atm.Decay }
	end
	local nubes = workspace.Terrain:FindFirstChildOfClass("Clouds")
	if nubes then sinShader.nubes, sinShader.nubesOn = nubes, nubes.Enabled end
	sinShader.original = table.clone(gfx)
end

local function aplicarGraficos()
	if aplicando then return end
	aplicando = true
	local ok, err = pcall(function()

		if sinShader.activo then
			for prop, v in pairs(sinShader.luz) do pcall(function() Lighting[prop] = v end) end
			for _, e in ipairs(Lighting:GetChildren()) do
				if e:IsA("PostEffect") then
					if sinShader.efectos[e] ~= nil then e.Enabled = sinShader.efectos[e]
					elseif e.Name:sub(1, 4) == "GFX_" then e.Enabled = false end
				elseif e:IsA("Atmosphere") then
					if e == sinShader.atm then
						for k, v in pairs(sinShader.atmProps) do e[k] = v end
					else
						e:Destroy()
					end
				end
			end
			if sinShader.atm and sinShader.atm.Parent ~= Lighting then sinShader.atm.Parent = Lighting end
			if cieloPropio then cieloPropio.Parent = nil end
			if SKYBOXES.actual then SKYBOXES.actual.Parent = nil end
			for _, sky in ipairs(cielosQuitados) do sky.Parent = Lighting end
			table.clear(cielosQuitados)
			local cielo = Lighting:FindFirstChildOfClass("Sky")
			if cielo and cielo:GetAttribute("GFX_Estrellas") ~= nil then cielo.StarCount = cielo:GetAttribute("GFX_Estrellas") end
			local nubes = workspace.Terrain:FindFirstChildOfClass("Clouds")
			if nubes then
				if nubes == sinShader.nubes then nubes.Enabled = sinShader.nubesOn else nubes.Enabled = false end
			end

			-- solo cielo (sin preset): pone el cielo y su luz sobre la iluminación normal del mapa
			SKYBOXES.conSol, SKYBOXES.sinSol = false, false
			local solo = gfx.skybox ~= "" and SKYBOXES.buscar(gfx.skybox)
			if solo then
				if not SKYBOXES.actual or SKYBOXES.actual.Name ~= "GFX_Sky_" .. solo[1] then
					if SKYBOXES.actual then SKYBOXES.actual:Destroy() end
					local nuevoSky = Instance.new("Sky")
					nuevoSky.Name = "GFX_Sky_" .. solo[1]
					for k, v in pairs(solo[2]) do nuevoSky[k] = v end
					SKYBOXES.actual = nuevoSky
				end
				for _, sk in ipairs(Lighting:GetChildren()) do
					if sk:IsA("Sky") and sk ~= SKYBOXES.actual then
						table.insert(cielosQuitados, sk)
						sk.Parent = nil
					end
				end
				SKYBOXES.actual.Parent = Lighting
				SKYBOXES.actual.SkyboxOrientation = Vector3.new(0, SKYBOXES.giro or gfx.skyGiro, 0)
				local luz = solo[3]
				if luz and gfx.skyLuz then
					local f = gfx.skyLuzFuerza
					Lighting.OutdoorAmbient = Lighting.OutdoorAmbient:Lerp(luz.exterior, f)
					Lighting.Ambient = Lighting.Ambient:Lerp(luz.ambiente, f)
					Lighting.ColorShift_Top = Color3.new(0, 0, 0):Lerp(luz.sol, 0.55 * f)
					Lighting.FogColor = luz.atm
					if sinShader.atm then
						sinShader.atm.Color = sinShader.atm.Color:Lerp(luz.atm, f)
						sinShader.atm.Decay = sinShader.atm.Decay:Lerp(luz.decay, f)
					end
					if luz.solDir and gfx.skySolAlinear then
						SKYBOXES.conSol = true
						local clave = solo[1] .. "_" .. gfx.skyGiro
						local sol = SKYBOXES.solCache[clave]
						if not sol then
							sol = { SKYBOXES.resolverSol(CFrame.Angles(0, math.rad(gfx.skyGiro), 0):VectorToWorldSpace(luz.solDir)) }
							SKYBOXES.solCache[clave] = sol
						end
						Lighting.ClockTime, Lighting.GeographicLatitude = sol[1], sol[2]
					elseif not luz.solDir then
						SKYBOXES.sinSol = true
						local function mas(c, m) return Color3.new(math.min(c.R * m, 1), math.min(c.G * m, 1), math.min(c.B * m, 1)) end
						Lighting.Brightness = 0
						Lighting.OutdoorAmbient = mas(Lighting.OutdoorAmbient, luz.oscuro and 1.35 or 1.55)
						Lighting.Ambient = mas(Lighting.Ambient, 1.3)
						Lighting.ExposureCompensation = Lighting.ExposureCompensation + 0.25
					end
				end
			end
			return
		end

		Lighting.ClockTime = gfx.hora
		Lighting.GeographicLatitude = gfx.latitud
		Lighting.Brightness = gfx.brillo
		Lighting.ExposureCompensation = gfx.exposicion
		Lighting.Ambient = gfx.ambiente
		Lighting.OutdoorAmbient = gfx.ambienteExterior
		Lighting.GlobalShadows = true
		pcall(function()
			Lighting.EnvironmentDiffuseScale = 1
			Lighting.EnvironmentSpecularScale = 1
			Lighting.EnvironmentDiffuseScale = 1
			Lighting.ShadowSoftness = gfx.sombraSuavidad
		end)

		if gfx.quitarNiebla then
			Lighting.FogStart = 0
			Lighting.FogEnd = 100000
		end

		-- Atmósfera limpia
		local atm = Lighting:FindFirstChildOfClass("Atmosphere")
		if not atm then
			atm = Instance.new("Atmosphere")
			atm.Parent = Lighting
		end
		atm.Density = gfx.atmDensidad
		atm.Offset = gfx.atmOffset
		atm.Haze = gfx.atmHaze
		atm.Glare = gfx.atmGlare
		atm.Color = gfx.atmColor
		atm.Decay = gfx.atmDecay

		-- skybox elegido en la sección Skys
		local datosSky = gfx.skybox ~= "" and SKYBOXES.buscar(gfx.skybox)
		if datosSky then
			if not SKYBOXES.actual or SKYBOXES.actual.Name ~= "GFX_Sky_" .. datosSky[1] then
				if SKYBOXES.actual then SKYBOXES.actual:Destroy() end
				local nuevoSky = Instance.new("Sky")
				nuevoSky.Name = "GFX_Sky_" .. datosSky[1]
				for k, v in pairs(datosSky[2]) do nuevoSky[k] = v end
				SKYBOXES.actual = nuevoSky
			end
		elseif SKYBOXES.actual then
			SKYBOXES.actual:Destroy()
			SKYBOXES.actual = nil
		end

		local propio = SKYBOXES.actual
		if not propio and gfx.cieloClaro then
			if not cieloPropio then
				cieloPropio = Instance.new("Sky")
				cieloPropio.Name = "GFX_Cielo"
				cieloPropio.SunAngularSize = 14
				cieloPropio.MoonAngularSize = 8
				cieloPropio.CelestialBodiesShown = true
				cieloPropio.StarCount = 0
			end
			propio = cieloPropio
		end
		if propio then
			for _, s in ipairs(Lighting:GetChildren()) do
				if s:IsA("Sky") and s ~= propio then
					if s ~= cieloPropio and s ~= SKYBOXES.actual then table.insert(cielosQuitados, s) end
					s.Parent = nil
				end
			end
			if cieloPropio and cieloPropio ~= propio then cieloPropio.Parent = nil end
			propio.Parent = Lighting
			if propio == SKYBOXES.actual then propio.SkyboxOrientation = Vector3.new(0, SKYBOXES.giro or gfx.skyGiro, 0) end
		else
			if cieloPropio then cieloPropio.Parent = nil end
			for _, sky in ipairs(cielosQuitados) do sky.Parent = Lighting end
			table.clear(cielosQuitados)
		end

		-- cielos con sol pintado: el sol de verdad (luz, sombras y efectos) se mueve a donde está el sol del cielo
		-- cielos de noche o sin sol: se quitan los efectos del sol pero la luz se queda
		local luzS = SKYBOXES.actual and datosSky and datosSky[3]
		SKYBOXES.conSol = luzS and luzS.solDir ~= nil and gfx.skySolAlinear or false
		SKYBOXES.sinSol = luzS ~= nil and luzS ~= false and luzS.solDir == nil
		if SKYBOXES.conSol and not gfx.noche then
			local clave = datosSky[1] .. "_" .. gfx.skyGiro
			local sol = SKYBOXES.solCache[clave]
			if not sol then
				local dir = CFrame.Angles(0, math.rad(gfx.skyGiro), 0):VectorToWorldSpace(luzS.solDir)
				sol = { SKYBOXES.resolverSol(dir) }
				SKYBOXES.solCache[clave] = sol
			end
			Lighting.ClockTime = sol[1]
			Lighting.GeographicLatitude = sol[2]
		end

		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("DepthOfFieldEffect") and e.Name ~= "GFX_Lejos" then e.Enabled = false end
		end
		local dof = efecto("DepthOfFieldEffect", "GFX_Lejos")
		dof.Enabled = gfx.lejosBorroso
		dof.FarIntensity = gfx.lejosIntensidad
		dof.FocusDistance = gfx.lejosFoco
		dof.InFocusRadius = gfx.lejosRadio
		dof.NearIntensity = gfx.cercaIntensidad or 0

		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("ColorCorrectionEffect") and e.Name:sub(1, 4) ~= "GFX_" then
				e.Enabled = false
			end
		end
		local cc = efecto("ColorCorrectionEffect", "GFX_Color")
		cc.Enabled = true
		cc.Saturation = gfx.saturacion
		cc.Contrast = gfx.contraste
		cc.Brightness = gfx.brilloColor
		cc.TintColor = gfx.tinte

		for _, e in ipairs(Lighting:GetChildren()) do
			if e:IsA("BloomEffect") and e.Name ~= "GFX_Bloom" then e.Enabled = false end
			if e:IsA("SunRaysEffect") and e.Name ~= "GFX_Rayos" then e.Enabled = false end
		end
		local bloom = efecto("BloomEffect", "GFX_Bloom")
		bloom.Enabled = true
		bloom.Intensity = gfx.bloomIntensidad
		bloom.Size = gfx.bloomTamano
		bloom.Threshold = gfx.bloomUmbral

		local rayos = efecto("SunRaysEffect", "GFX_Rayos")
		rayos.Enabled = true
		rayos.Intensity = SKYBOXES.sinSol and 0 or gfx.rayosIntensidad
		rayos.Spread = gfx.rayosAlcance

		-- Nubes blancas suaves
		if gfx.nubes ~= nil then
			local nubes = workspace.Terrain:FindFirstChildOfClass("Clouds")
			if not nubes then
				nubes = Instance.new("Clouds")
				nubes.Parent = workspace.Terrain
			end
			nubes.Enabled = gfx.nubes
			nubes.Cover = 0.45
			nubes.Density = 0.55
			nubes.Color = Color3.fromRGB(255, 255, 255)
		end

		local cielo = Lighting:FindFirstChildOfClass("Sky")
		if cielo and cielo:GetAttribute("GFX_Estrellas") == nil then
			cielo:SetAttribute("GFX_Estrellas", cielo.StarCount)
		end
		if gfx.noche then
			Lighting.ClockTime = gfx.nocheHora
			Lighting.Brightness = gfx.nocheLuna
			Lighting.ExposureCompensation = gfx.nocheExposicion
			Lighting.Ambient = gfx.nocheAmbiente
			Lighting.OutdoorAmbient = gfx.nocheExterior
			atm.Color = Color3.fromRGB(64, 76, 110)
			atm.Decay = Color3.fromRGB(34, 42, 66)
			atm.Glare = 0
			atm.Haze = math.min(gfx.atmHaze, 1.2)
			cc.TintColor = gfx.nocheTinte
			cc.Saturation = gfx.saturacion - 0.15
			rayos.Intensity = 0
			bloom.Intensity = math.max(gfx.bloomIntensidad, 0.6)
			bloom.Threshold = 0.85
			if cielo then
				cielo.StarCount = gfx.nocheEstrellas
				cielo.CelestialBodiesShown = true
			end
			if gfx.aurora then
				Lighting.OutdoorAmbient = gfx.nocheExterior:Lerp(Color3.fromRGB(80, 150, 130), 0.35)
				Lighting.Ambient = gfx.nocheAmbiente:Lerp(Color3.fromRGB(60, 110, 100), 0.3)
				atm.Density = math.min(atm.Density, 0.22)
				atm.Haze = 0
				atm.Color = Color3.fromRGB(40, 80, 82)
				atm.Decay = Color3.fromRGB(20, 40, 62)
				bloom.Intensity = math.max(gfx.bloomIntensidad, 0.9)
				bloom.Threshold = 0.7
			end
		elseif cielo and cielo:GetAttribute("GFX_Estrellas") ~= nil then
			cielo.StarCount = cielo:GetAttribute("GFX_Estrellas")
		end

		local nubesL = workspace.Terrain:FindFirstChildOfClass("Clouds")
		if gfx.lluvia then
			local k = gfx.lluviaOscurecer
			Lighting.Brightness = Lighting.Brightness * (1 - k * 0.3)
			Lighting.ExposureCompensation = Lighting.ExposureCompensation + 0.05
			if not gfx.noche then
				Lighting.OutdoorAmbient = Color3.fromRGB(138, 142, 150)
				Lighting.Ambient = Color3.fromRGB(96, 98, 104)
			end
			pcall(function() Lighting.ShadowSoftness = math.max(gfx.sombraSuavidad, 0.6) end)
			atm.Density = math.max(atm.Density, 0.5 + k * 0.1)
			atm.Haze = math.max(atm.Haze, 2.6)
			atm.Glare = 0
			atm.Offset = 0.05
			if not gfx.noche then
				atm.Color = Color3.fromRGB(150, 158, 168)
				atm.Decay = Color3.fromRGB(90, 96, 106)
			end
			cc.Saturation = cc.Saturation - 0.2
			cc.Contrast = cc.Contrast + 0.05
			rayos.Intensity = 0
			if not nubesL then
				nubesL = Instance.new("Clouds")
				nubesL.Parent = workspace.Terrain
			end
			nubesL.Enabled = true
			nubesL.Cover = 0.92
			nubesL.Density = 0.85
			nubesL.Color = gfx.noche and Color3.fromRGB(30, 33, 40) or Color3.fromRGB(95, 100, 110)
		end

		if gfx.lluvia and gfx.tormenta and nubesL then
			Lighting.Brightness = Lighting.Brightness * 0.9
			Lighting.ExposureCompensation = Lighting.ExposureCompensation + 0.1
			pcall(function() Lighting.ShadowSoftness = 0.85 end)
			atm.Density = math.max(atm.Density, 0.6)
			atm.Haze = math.max(atm.Haze, 3)
			atm.Offset = 0
			atm.Glare = 0
			if not gfx.noche then
				atm.Color = Color3.fromRGB(150, 158, 170)
				atm.Decay = Color3.fromRGB(78, 84, 96)
			end
			cc.Saturation = cc.Saturation - 0.15
			cc.Contrast = cc.Contrast + 0.08
			cc.TintColor = cc.TintColor:Lerp(Color3.fromRGB(215, 225, 240), 0.6)
			nubesL.Cover = 1
			nubesL.Density = 1
			nubesL.Color = gfx.noche and Color3.fromRGB(30, 33, 40) or Color3.fromRGB(78, 82, 92)
		end
		if cielo then
			if cielo:GetAttribute("GFX_Astros") == nil then cielo:SetAttribute("GFX_Astros", cielo.CelestialBodiesShown) end
			if gfx.lluvia and gfx.tormenta then
				cielo.CelestialBodiesShown = false
			elseif not gfx.noche then
				cielo.CelestialBodiesShown = cielo:GetAttribute("GFX_Astros")
			end
		end
		if nubesL and gfx.nubes == false and not gfx.lluvia then
			nubesL.Enabled = false
		end

		-- cada cielo pinta la luz con sus colores (cielo morado = luz morada) y deja el cielo claro
		local luzSky = SKYBOXES.actual and datosSky and datosSky[3]
		if luzSky and gfx.skyLuz then
			local k = gfx.noche and 0.7 or 1
			local function escala(c) return Color3.new(c.R * k, c.G * k, c.B * k) end
			local f = gfx.skyLuzFuerza
			Lighting.OutdoorAmbient = Lighting.OutdoorAmbient:Lerp(escala(luzSky.exterior), f)
			Lighting.Ambient = Lighting.Ambient:Lerp(escala(luzSky.ambiente), f)
			Lighting.ColorShift_Top = Color3.new(0, 0, 0):Lerp(luzSky.sol, 0.55 * f)
			Lighting.FogColor = luzSky.atm
			cc.TintColor = cc.TintColor:Lerp(luzSky.tinte, f)
			if not gfx.lluvia then
				atm.Color = atm.Color:Lerp(luzSky.atm, f)
				atm.Decay = atm.Decay:Lerp(luzSky.decay, f)
				-- cielo claro: poca bruma para que el skybox se vea limpio
				atm.Density = math.min(atm.Density, 0.3)
				atm.Haze = math.min(atm.Haze, 0.8)
				atm.Glare = SKYBOXES.sinSol and 0 or math.min(atm.Glare, 0.4)
				if luzSky.oscuro and not gfx.noche then
					Lighting.Brightness = Lighting.Brightness * 0.8
				end
			end
			if SKYBOXES.sinSol then
				-- sin sol en el cielo: nada de luz directa (ni brillo del sol en el piso), luz suave de todo el cielo
				local function mas(c, m) return Color3.new(math.min(c.R * m, 1), math.min(c.G * m, 1), math.min(c.B * m, 1)) end
				Lighting.Brightness = 0
				Lighting.OutdoorAmbient = mas(Lighting.OutdoorAmbient, luzSky.oscuro and 1.35 or 1.55)
				Lighting.Ambient = mas(Lighting.Ambient, 1.3)
				Lighting.ExposureCompensation = Lighting.ExposureCompensation + 0.25
			end
		else
			Lighting.ColorShift_Top = Color3.new(0, 0, 0)
		end

		-- relleno de sombras: el lado que no recibe luz no queda tan oscuro
		local relleno = gfx.rellenoSombra or 0
		if relleno > 0 then
			local function aclarar(c, k)
				return Color3.new(math.min(c.R * (1 + k) + k * 0.06, 1), math.min(c.G * (1 + k) + k * 0.06, 1), math.min(c.B * (1 + k) + k * 0.06, 1))
			end
			Lighting.OutdoorAmbient = aclarar(Lighting.OutdoorAmbient, relleno)
			Lighting.Ambient = aclarar(Lighting.Ambient, relleno * 0.8)
			pcall(function() Lighting.EnvironmentDiffuseScale = math.min(1, 0.7 + relleno) end)
		end

		local extra = gfx.nieblaCercana or 0
		if extra > 0 then
			atm.Density = math.clamp(atm.Density + extra * 0.45, 0, 0.95)
			atm.Offset = math.max(atm.Offset - extra * 0.4, 0)
			atm.Haze = atm.Haze + extra * 1.5
		end

	end)
	aplicando = false
	sinShader.ultimo = os.clock()
	if not ok then warn("[4Phant0nmnn] " .. tostring(err)) end
end

aplicarGraficos()

-- giro lento del skybox (nubes que se mueven)
RunService.Heartbeat:Connect(function(dt)
	local sky = SKYBOXES.actual
	if not sky or sky.Parent ~= Lighting then return end
	local giro = gfx.skyGiro
	if gfx.skyVelocidad ~= 0 and not SKYBOXES.conSol then
		SKYBOXES.avance = ((SKYBOXES.avance or 0) + gfx.skyVelocidad * dt) % 360
		giro = (giro + SKYBOXES.avance) % 360
	end
	if SKYBOXES.giro ~= giro then
		SKYBOXES.giro = giro
		sky.SkyboxOrientation = Vector3.new(0, giro, 0)
	end
end)

local pendiente = false
local function reaplicar()
	-- ignora los cambios que hace el propio shader (si no, se reaplica sin parar y se traba)
	if pendiente or aplicando or os.clock() - (sinShader.ultimo or 0) < 0.1 then return end
	pendiente = true
	task.delay(0.25, function()
		pendiente = false
		aplicarGraficos()
	end)
end
Lighting.Changed:Connect(reaplicar)
Lighting.ChildAdded:Connect(reaplicar)
Lighting.DescendantAdded:Connect(reaplicar)

for _, d in ipairs(workspace.CurrentCamera:GetChildren()) do
	if d.Name == "GFX_MotionBlur" then d:Destroy() end
end

local emPolvo, emDestellos, emArena
do
	local caja = Instance.new("Part")
	caja.Name = "GFX_Polvo"
	caja.Anchored = true
	caja.CanCollide = false
	caja.CanQuery = false
	caja.CanTouch = false
	caja.CastShadow = false
	caja.Transparency = 1
	caja.Size = Vector3.new(90, 35, 90)

	local p = Instance.new("ParticleEmitter")
	p.Shape = Enum.ParticleEmitterShape.Box
	p.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	p.Rate = gfx.polvoCantidad
	p.Lifetime = NumberRange.new(6, 10)
	p.Speed = NumberRange.new(0.2, 0.8)
	p.SpreadAngle = Vector2.new(180, 180)
	p.Acceleration = Vector3.new(0.4, -0.05, 0.2)
	p.Rotation = NumberRange.new(0, 360)
	p.RotSpeed = NumberRange.new(-20, 20)
	p.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.05),
		NumberSequenceKeypoint.new(0.5, 0.12),
		NumberSequenceKeypoint.new(1, 0.05),
	})
	p.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.2, 0.55),
		NumberSequenceKeypoint.new(0.8, 0.55),
		NumberSequenceKeypoint.new(1, 1),
	})
	p.Color = ColorSequence.new(gfx.polvoColor)
	p.LightEmission = 0.4
	p.LightInfluence = 0.6
	p.Parent = caja
	emPolvo = p

	-- motitas que brillan con el sol
	local d = Instance.new("ParticleEmitter")
	d.Name = "Destellos"
	d.Shape = Enum.ParticleEmitterShape.Box
	d.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	d.Rate = gfx.destellosCantidad
	d.Lifetime = NumberRange.new(4, 8)
	d.Speed = NumberRange.new(0.1, 0.5)
	d.SpreadAngle = Vector2.new(180, 180)
	d.Acceleration = Vector3.new(0.3, 0.05, 0.15)
	d.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.5, 0.18),
		NumberSequenceKeypoint.new(1, 0),
	})
	d.Transparency = NumberSequence.new(0.2)
	d.Color = ColorSequence.new(Color3.fromRGB(255, 225, 170))
	d.LightEmission = 1
	d.LightInfluence = 0.2
	d.Parent = caja
	emDestellos = d

	-- nubecitas de arena que pasan con el viento
	local a = Instance.new("ParticleEmitter")
	a.Name = "ArenaViento"
	a.Texture = "rbxasset://textures/particles/smoke_main.dds"
	a.Shape = Enum.ParticleEmitterShape.Box
	a.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	a.Rate = gfx.arenaCantidad
	a.Lifetime = NumberRange.new(5, 9)
	a.Speed = NumberRange.new(2, 5)
	a.EmissionDirection = Enum.NormalId.Right
	a.SpreadAngle = Vector2.new(20, 10)
	a.Rotation = NumberRange.new(0, 360)
	a.RotSpeed = NumberRange.new(-10, 10)
	a.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 3),
		NumberSequenceKeypoint.new(1, 7),
	})
	a.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.3, 0.88),
		NumberSequenceKeypoint.new(0.7, 0.88),
		NumberSequenceKeypoint.new(1, 1),
	})
	a.Color = ColorSequence.new(gfx.polvoColor)
	a.LightEmission = 0.1
	a.LightInfluence = 1
	a.Parent = caja
	emArena = a

	caja.Parent = workspace

	RunService.RenderStepped:Connect(function()
		caja.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)
	end)
end

local function actualizarParticulas()
	emPolvo.Enabled = gfx.polvo and gfx.polvoCantidad > 0
	emPolvo.Rate = gfx.polvoCantidad
	emDestellos.Enabled = gfx.polvo and gfx.destellosCantidad > 0
	emDestellos.Rate = gfx.destellosCantidad
	emArena.Enabled = gfx.polvo and gfx.arenaCantidad > 0
	emArena.Rate = gfx.arenaCantidad
	emPolvo.Color = ColorSequence.new(gfx.polvoColor)
	emArena.Color = ColorSequence.new(gfx.polvoColor)
end
actualizarParticulas()

local vinetaGui
local vinetaGrads = {}
do
	local vg = Instance.new("ScreenGui")
	vinetaGui = vg
	vg.Name = "GFX_Vineta"
	vg.IgnoreGuiInset = true
	vg.ResetOnSpawn = false
	vg.DisplayOrder = -999
	local function orilla(pos, size, rot)
		local f = Instance.new("Frame")
		f.BorderSizePixel = 0
		f.BackgroundColor3 = Color3.new(0, 0, 0)
		f.Position = pos
		f.Size = size
		local g = Instance.new("UIGradient")
		g.Rotation = rot
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1 - gfx.vinetaFuerza),
			NumberSequenceKeypoint.new(1, 1),
		})
		g.Parent = f
		f.Parent = vg
		table.insert(vinetaGrads, g)
	end
	orilla(UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.28), 90)
	orilla(UDim2.fromScale(0, 0.72), UDim2.fromScale(1, 0.28), -90)
	orilla(UDim2.fromScale(0, 0), UDim2.fromScale(0.22, 1), 0)
	orilla(UDim2.fromScale(0.78, 0), UDim2.fromScale(0.22, 1), 180)
	vg.Parent = player:WaitForChild("PlayerGui")
end

local function actualizarVineta()
	vinetaGui.Enabled = gfx.vineta
	for _, g in ipairs(vinetaGrads) do
		g.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1 - gfx.vinetaFuerza),
			NumberSequenceKeypoint.new(1, 1),
		})
	end
end
actualizarVineta()

local aguaOriginal = {}
pcall(function()
	local t = workspace.Terrain
	aguaOriginal = { t.WaterReflectance, t.WaterTransparency, t.WaterWaveSize, t.WaterWaveSpeed }
end)
local function actualizarAgua()
	local t = workspace.Terrain
	pcall(function()
		if gfx.aguaReflejo then
			t.WaterReflectance = 1
			t.WaterTransparency = 0.35
			t.WaterWaveSize = 0.08
			t.WaterWaveSpeed = 6
		elseif aguaOriginal[1] then
			t.WaterReflectance = aguaOriginal[1]
			t.WaterTransparency = aguaOriginal[2]
			t.WaterWaveSize = aguaOriginal[3]
			t.WaterWaveSpeed = aguaOriginal[4]
		end
	end)
end
actualizarAgua()

local pisosHechos = setmetatable({}, { __mode = "k" })

local function esPersonaje(inst)
	local m = inst:FindFirstAncestorOfClass("Model")
	while m do
		if m:FindFirstChildOfClass("Humanoid") then return true end
		m = m:FindFirstAncestorOfClass("Model")
	end
	return false
end

local function hacerVisibleReflejoEnTexturas(p)
	if gfx.texturaTransparenciaMin <= 0 then return end
	for _, t in ipairs(p:GetChildren()) do
		if (t:IsA("Texture") or t:IsA("Decal")) and t.Transparency < gfx.texturaTransparenciaMin then
			t.Transparency = gfx.texturaTransparenciaMin
		end
	end
end

local barnices = 0
local CARAS_BARNIZ = {
	[Enum.NormalId.Top] = { Vector3.new(0, 1, 0), "Y" },
	[Enum.NormalId.Bottom] = { Vector3.new(0, -1, 0), "Y" },
	[Enum.NormalId.Front] = { Vector3.new(0, 0, -1), "Z" },
	[Enum.NormalId.Back] = { Vector3.new(0, 0, 1), "Z" },
	[Enum.NormalId.Right] = { Vector3.new(1, 0, 0), "X" },
	[Enum.NormalId.Left] = { Vector3.new(-1, 0, 0), "X" },
}

local vidrios = 0
local listaPisos, listaParedes, listaVidrios, listaBarniz = {}, {}, {}, {}

local function aplicarVidrio(v)
	local activo = gfx.pisosBrillantes and gfx.pisoVidrio
	v.Transparency = activo and gfx.vidrioTransparencia or 1
	v.Reflectance = gfx.vidrioReflectance
	v.Color = gfx.vidrioColor
end

local function ponerVidrio(p)
	if vidrios >= gfx.vidrioMax then return end
	if p.ClassName ~= "Part" or p.Shape ~= Enum.PartType.Block then return end
	if p:FindFirstChild("GFX_Vidrio") then return end
	vidrios += 1
	local v = Instance.new("Part")
	v.Name = "GFX_Vidrio"
	v.Anchored = true
	v.CanCollide = false
	v.CanQuery = false
	v.CanTouch = false
	v.CastShadow = false
	v.Material = Enum.Material.Glass
	v.Size = Vector3.new(p.Size.X, 0.06, p.Size.Z)
	v.CFrame = p.CFrame * CFrame.new(0, p.Size.Y / 2 + 0.035, 0)
	aplicarVidrio(v)
	v.Parent = p
	table.insert(listaVidrios, v)
end

local function aplicarBarniz(b)
	local capa, esArribaDePiso, piso = b[1], b[2], b[3]
	local fuerza = 0
	if gfx.barniz then
		fuerza = gfx.barnizFuerza
		if esArribaDePiso then
			if gfx.pisosBrillantes and gfx.pisoVidrio and piso:FindFirstChild("GFX_Vidrio") then
				fuerza = 0
			elseif gfx.pisoMojado and gfx.pisosBrillantes then
				fuerza = gfx.mojadoBarniz
			end
		end
	end
	-- el barniz es un espejo; con poca nitidez casi no se nota y queda un brillo suave
	capa.Transparency = 1 - math.clamp(fuerza * (gfx.reflejoNitidez or 1), 0, 1)
end

local function ponerBarniz(p)
	if p.ClassName ~= "Part" or p.Shape ~= Enum.PartType.Block then return end
	local hechas = {}
	for _, c in ipairs(p:GetChildren()) do
		if c.Name:sub(1, 11) == "GFX_Barniz_" then hechas[c.Name] = true end
	end
	for _, t in ipairs(p:GetChildren()) do
		if (t:IsA("Texture") or t:IsA("Decal")) and t.Transparency < 1 then
			local nombre = "GFX_Barniz_" .. t.Face.Name
			if not hechas[nombre] and barnices < gfx.barnizMax then
				hechas[nombre] = true
				barnices += 1
				local info = CARAS_BARNIZ[t.Face]
				local n, eje = info[1], info[2]
				local size = p.Size
				local mitad = size[eje] / 2
				local nuevo = Vector3.new(
					eje == "X" and 0.02 or size.X,
					eje == "Y" and 0.02 or size.Y,
					eje == "Z" and 0.02 or size.Z
				)
				local capa = Instance.new("Part")
				capa.Name = nombre
				capa.Anchored = true
				capa.CanCollide = false
				capa.CanQuery = false
				capa.CanTouch = false
				capa.CastShadow = false
				capa.Material = Enum.Material.SmoothPlastic
				capa.Reflectance = 1
				capa.Size = nuevo
				capa.CFrame = p.CFrame * CFrame.new(n * (mitad + 0.012))
				local b = { capa, t.Face == Enum.NormalId.Top and p.CFrame.UpVector.Y >= 0.99, p }
				aplicarBarniz(b)
				capa.Parent = p
				table.insert(listaBarniz, b)
			end
		end
	end
end

-- cuánto brilla cada material: tierra y pasto poco, piedra medio, plástico/mármol/metal mucho
local BRILLO_MATERIAL = {
	Grass = 0.35, LeafyGrass = 0.35, Ground = 0.4, Sand = 0.4, Mud = 0.55, Snow = 0.55, Salt = 0.45, Fabric = 0.3,
	Rock = 0.6, Slate = 0.65, Basalt = 0.6, Sandstone = 0.55, Limestone = 0.6, Cobblestone = 0.6, Brick = 0.55,
	Concrete = 0.6, Pavement = 0.65, Asphalt = 0.65, CrackedLava = 0.6, Wood = 0.65, WoodPlanks = 0.65,
	CorrodedMetal = 0.65, Plastic = 0.85, SmoothPlastic = 1, Marble = 1, Granite = 0.9, Metal = 0.9,
	DiamondPlate = 0.9, Foil = 1, Glass = 1, Ice = 1, Glacier = 0.95, Pebble = 0.55,
}

local baseReflejo = setmetatable({}, { __mode = "k" })

-- misma regla para pisos, paredes, cuñas y cualquier forma: así las uniones no se notan
local function aplicarSuperficie(p, esPiso)
	local orig = p:GetAttribute("GFX_RefOrig") or 0
	local colorOrig = p:GetAttribute("GFX_ColorOrig") or p.Color
	local activo = (esPiso and gfx.pisosBrillantes) or ((not esPiso) and gfx.superficiesBrillantes) or (gfx.pisosBrillantes and gfx.superficiesBrillantes)
	if not activo then
		baseReflejo[p] = nil
		p.Reflectance = orig
		p.Color = colorOrig
		return
	end
	local mat = BRILLO_MATERIAL[p:GetAttribute("GFX_MatOrig") or p.Material.Name] or 0.7
	local arriba = math.clamp(p.CFrame.UpVector.Y, 0, 1)
	local base = gfx.pisoMojado and gfx.mojadoReflectance or gfx.pisoReflectance
	if gfx.lluvia then base = math.max(base, 0.45) end
	-- las caras que miran de lado brillan un poco menos, pero sin salto brusco
	-- poco espejo (Reflectance es un espejo nítido) y más brillo difuso de la luz del entorno
	local refl = base * mat * (0.7 + 0.3 * arriba) * gfx.reflejoNitidez
	refl = math.max(orig, math.min(refl, 0.42))
	baseReflejo[p] = refl
	p.Reflectance = refl
	if gfx.pisoMojado then
		local h, sat, v = colorOrig:ToHSV()
		local k = gfx.mojadoOscurecer * (0.5 + 0.5 * arriba)
		p.Color = Color3.fromHSV(h, math.min(sat * 1.1, 1), v * (1 - k))
	else
		p.Color = colorOrig
	end
end
local function aplicarPiso(p) aplicarSuperficie(p, true) end
local function aplicarPared(p) aplicarSuperficie(p, false) end

local function brillarPiso(p)
	if pisosHechos[p] then return end
	if p.Name:sub(1, 4) == "GFX_" then return end
	if not p:IsA("BasePart") or p:IsA("Terrain") then return end
	if not p.Anchored or p.Transparency > 0.05 then return end
	if p.Material == Enum.Material.Neon or p.Material == Enum.Material.ForceField then return end
	if p:FindFirstChildOfClass("SurfaceAppearance") then return end
	if esPersonaje(p) then return end

	local lado = math.min(p.Size.X, p.Size.Z)
	local esPiso = not (p:IsA("WedgePart") or p:IsA("CornerWedgePart") or p:IsA("TrussPart"))
		and p.CFrame.UpVector.Y >= 0.99
		and lado >= gfx.pisoLadoMinimo and p.Size.Y <= lado

	pisosHechos[p] = true
	if p:GetAttribute("GFX_RefOrig") == nil then
		p:SetAttribute("GFX_RefOrig", p.Reflectance)
		p:SetAttribute("GFX_ColorOrig", p.Color)
		p:SetAttribute("GFX_MatOrig", p.Material.Name)
	else
		local m = p:GetAttribute("GFX_MatOrig")
		if m and Enum.Material[m] then p.Material = Enum.Material[m] end
	end

	if esPiso then
		table.insert(listaPisos, p)
		aplicarPiso(p)
		ponerVidrio(p)
	else
		table.insert(listaParedes, p)
		aplicarPared(p)
	end
	hacerVisibleReflejoEnTexturas(p)
	ponerBarniz(p)

	p.ChildAdded:Connect(function(c)
		if c:IsA("Texture") or c:IsA("Decal") then
			task.defer(function()
				hacerVisibleReflejoEnTexturas(p)
				ponerBarniz(p)
			end)
		end
	end)
end

-- reflejo que cambia según cómo lo miras (como en la vida real): mirando de lejos/rasante brilla más,
-- mirando hacia tus pies brilla menos. Así no parece una imagen pegada al piso.
do
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.RespectCanCollide = false
	task.spawn(function()
		while true do
			task.wait(0.12)
			local cam = workspace.CurrentCamera
			if cam and next(baseReflejo) and not sinShader.activo then
				local ojo = cam.CFrame.Position
				local cerca = workspace:GetPartBoundsInRadius(ojo, 110, params)
				for _, p in ipairs(cerca) do
					local base = baseReflejo[p]
					if base and base > 0.01 then
						local n = p.CFrame.UpVector
						local hacia = p.Position - ojo
						local dist = hacia.Magnitude
						if dist > 0.1 then
							local cosA = math.abs(n:Dot(hacia / dist))
							local rasante = (1 - cosA) ^ 2
							p.Reflectance = math.min(base * (0.35 + 1.1 * rasante), 0.6)
						end
					end
				end
			end
		end
	end)
end

task.spawn(function()
	for i, d in ipairs(workspace:GetDescendants()) do
		brillarPiso(d)
		if i % 1000 == 0 then task.wait() end
	end
end)
-- mapas que se cargan en cada ronda
workspace.DescendantAdded:Connect(function(d)
	if d:IsA("BasePart") then
		task.defer(function()
			if d.Parent then brillarPiso(d) end
		end)
	end
end)

local versionSuperficies = 0
local function actualizarSuperficies()
	versionSuperficies += 1
	local mia = versionSuperficies
	task.spawn(function()
		local n = 0
		local function paso()
			n += 1
			if n % 400 == 0 then task.wait() end
			return mia == versionSuperficies
		end
		for _, p in ipairs(listaPisos) do
			if p.Parent then aplicarPiso(p) end
			if not paso() then return end
		end
		for _, p in ipairs(listaParedes) do
			if p.Parent then aplicarPared(p) end
			if not paso() then return end
		end
		for _, v in ipairs(listaVidrios) do
			if v.Parent then aplicarVidrio(v) end
			if not paso() then return end
		end
		for _, b in ipairs(listaBarniz) do
			if b[1].Parent then aplicarBarniz(b) end
			if not paso() then return end
		end
	end)
end

local ref = {
	activado = true,
	reflejoOpacidad = 0.6,
	reflejoCapas = 9,
	reflejoArrastre = 0.7,
	reflejoDesenfoque = 1.7,
	reflejoCaida = 0.83,
	desvanecerProfundidad = 10,
	reflejoTinte = Color3.fromRGB(150, 120, 95),
	reflejoAmbiente = Color3.fromRGB(120, 105, 92),
	alturaMax = 40,
	desvanecerDesde = 15,
	minPlano = 0.9,
	tagExcluir = "SinReflejo",
	soloMateriales = nil,
	carpetaAvatares = "SM_Players",
	-- reflejo del escenario cercano (paredes, cosas, árboles) para que el piso no parezca una foto fija
	escenario = false,
	escenaRadio = 55,
	escenaMax = 140,
	escenaCapas = 2,
	escenaBorroso = 0.25,
	escenaOpacidad = 0.5,
	escenaFade = 28,
}

local cam = workspace.CurrentCamera

local gui = Instance.new("ScreenGui")
gui.Name = "RF_ReflejoPiso"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = -1000

local vista = Instance.new("ViewportFrame")
vista.Name = "Vista"
vista.BackgroundTransparency = 1
vista.Size = UDim2.fromScale(1, 1)
vista.ImageTransparency = 1 - ref.reflejoOpacidad
vista.ImageColor3 = ref.reflejoTinte
vista.Ambient = ref.reflejoAmbiente
vista.LightColor = Color3.fromRGB(255, 255, 255)
vista.LightDirection = Vector3.new(-0.4, 1, -0.3)
vista.Parent = gui

local camVista = Instance.new("Camera")
camVista.Parent = vista
vista.CurrentCamera = camVista

local mundo = Instance.new("WorldModel")
mundo.Parent = vista

gui.Parent = player:WaitForChild("PlayerGui")

local CAPAS = {}
for k = 1, ref.reflejoCapas do CAPAS[k] = { offset = Vector3.zero, opacidad = 1 } end

local function actualizarReflejo()
	gui.Enabled = ref.activado
	vista.ImageTransparency = 1 - ref.reflejoOpacidad
	vista.ImageColor3 = ref.reflejoTinte
	vista.Ambient = ref.reflejoAmbiente
	for k = 0, ref.reflejoCapas - 1 do
		local t = (ref.reflejoCapas > 1) and k / (ref.reflejoCapas - 1) or 0
		local ang = k * 2.39996
		local capa = CAPAS[k + 1]
		capa.offset = Vector3.new(
			math.cos(ang) * ref.reflejoDesenfoque * t,
			-k * ref.reflejoArrastre,
			math.sin(ang) * ref.reflejoDesenfoque * t
		)
		capa.opacidad = ref.reflejoCaida ^ k
	end
end
actualizarReflejo()

local function espejo(cf, h)
	local p = cf.Position
	local x, y, z = cf.XVector, cf.YVector, cf.ZVector
	return CFrame.fromMatrix(
		Vector3.new(p.X, 2 * h - p.Y, p.Z),
		Vector3.new(-x.X, x.Y, -x.Z),
		Vector3.new(y.X, -y.Y, y.Z),
		Vector3.new(z.X, -z.Y, z.Z)
	)
end

local reflejos = {}

local function limpiarClon(clon)
	for _, d in ipairs(clon:GetDescendants()) do
		if d:IsA("JointInstance") or d:IsA("WeldConstraint") or d:IsA("BaseScript")
			or d:IsA("BillboardGui") or d:IsA("SurfaceGui") or d:IsA("Sound")
			or d:IsA("Animator") or d:IsA("ParticleEmitter") or d:IsA("Trail")
			or d:IsA("Beam") or d:IsA("Light") or d:IsA("ValueBase")
			or d:IsA("ForceField") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
			d:Destroy()
		elseif d:IsA("BasePart") then
			d.Anchored = true
			d.CanCollide = false
			d.CanQuery = false
			d.CanTouch = false
			d.CastShadow = false
		end
	end
	local hum = clon:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		pcall(function() hum.EvaluateStateMachine = false end)
	end
end

local function destruirClones(r)
	if r and r.clones then
		for _, c in ipairs(r.clones) do c:Destroy() end
	end
end

local function construir(modelo)
	destruirClones(reflejos[modelo])

	local originales, i = {}, 0
	for _, d in ipairs(modelo:GetDescendants()) do
		if d:IsA("BasePart") then
			i += 1
			d:SetAttribute("RF_Id", i)
			originales[i] = d
		end
	end

	local arch = modelo.Archivable
	modelo.Archivable = true
	local ok, base = pcall(function() return modelo:Clone() end)
	modelo.Archivable = arch
	if not ok or not base then return end
	limpiarClon(base)

	local clones, pares = {}, {}
	for k, capa in ipairs(CAPAS) do
		local clon = (k == 1) and base or base:Clone()
		clon.Name = "Reflejo_" .. modelo.Name .. "_" .. k
		for _, d in ipairs(clon:GetDescendants()) do
			if d:IsA("BasePart") then
				local id = d:GetAttribute("RF_Id")
				local o = id and originales[id]
				if o then
					local decals = {}
					for _, dc in ipairs(d:GetChildren()) do
						if dc:IsA("Decal") then table.insert(decals, { dc, dc.Transparency }) end
					end
					table.insert(pares, { o, d, capa, decals })
				else
					d:Destroy()
				end
			end
		end
		clon.Parent = mundo
		table.insert(clones, clon)
	end

	reflejos[modelo] = { clones = clones, pares = pares, sucio = false }
end

local function marcarSucio(modelo)
	local r = reflejos[modelo]
	if r and not r.sucio then
		r.sucio = true
		task.delay(1, function()
			if modelo.Parent then construir(modelo) end
		end)
	end
end

local function vigilar(modelo)
	if not modelo:IsA("Model") or reflejos[modelo] then return end
	reflejos[modelo] = { pares = {}, sucio = false }
	task.delay(0.5, function()
		if modelo.Parent then construir(modelo) end
	end)
	modelo.DescendantAdded:Connect(function(d)
		if d:IsA("BasePart") or d:IsA("Clothing") then marcarSucio(modelo) end
	end)
	modelo.DescendantRemoving:Connect(function(d)
		if d:IsA("BasePart") then marcarSucio(modelo) end
	end)
	modelo.AncestryChanged:Connect(function(_, padre)
		if padre == nil then
			destruirClones(reflejos[modelo])
			reflejos[modelo] = nil
		end
	end)
end

local function vigilarJugador(pl)
	if pl.Character then vigilar(pl.Character) end
	pl.CharacterAdded:Connect(vigilar)
end
for _, pl in ipairs(Players:GetPlayers()) do vigilarJugador(pl) end
Players.PlayerAdded:Connect(vigilarJugador)

task.spawn(function()
	local carpeta = workspace:WaitForChild(ref.carpetaAvatares, 10)
	if not carpeta then return end
	for _, m in ipairs(carpeta:GetChildren()) do vigilar(m) end
	carpeta.ChildAdded:Connect(vigilar)
end)

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function actualizarFiltro()
	local excluir = {}
	for _, pl in ipairs(Players:GetPlayers()) do
		if pl.Character then table.insert(excluir, pl.Character) end
	end
	local av = workspace:FindFirstChild(ref.carpetaAvatares)
	if av then table.insert(excluir, av) end
	for _, c in ipairs(workspace:GetChildren()) do
		if c.Name:sub(1, 9) == "SM_Local_" then table.insert(excluir, c) end
	end
	rayParams.FilterDescendantsInstances = excluir
end
actualizarFiltro()
task.spawn(function()
	while true do
		task.wait(1)
		actualizarFiltro()
	end
end)

local abajo = Vector3.new(0, -(ref.alturaMax + 10), 0)

local function pisoBajo(raiz)
	local hit = workspace:Raycast(raiz.Position, abajo, rayParams)
	local intentos = 0
	while hit and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain")
		and hit.Instance.Transparency >= 0.9 and intentos < 4 do
		intentos += 1
		rayParams:AddToFilter(hit.Instance)
		hit = workspace:Raycast(raiz.Position, abajo, rayParams)
	end
	if not hit then return nil end
	if hit.Normal.Y < ref.minPlano then return nil end
	local inst = hit.Instance
	if CollectionService:HasTag(inst, ref.tagExcluir) then return nil end
	if ref.soloMateriales and not ref.soloMateriales[hit.Material] then return nil end
	return hit.Position.Y
end

RunService:BindToRenderStep("RF_ReflejoPiso", Enum.RenderPriority.Last.Value + 50, function()
	if not ref.activado then return end
	cam = workspace.CurrentCamera
	camVista.CFrame = cam.CFrame
	camVista.FieldOfView = cam.FieldOfView

	for modelo, r in pairs(reflejos) do
		if r.clones and #r.pares > 0 then
			local raiz = modelo:FindFirstChild("HumanoidRootPart") or modelo.PrimaryPart or r.pares[1][1]
			local h = raiz and raiz.Parent and pisoBajo(raiz)

			if h then
				local altura = raiz.Position.Y - h
				local fadeAltura = 1
				if altura > ref.desvanecerDesde then
					fadeAltura = 1 - math.clamp((altura - ref.desvanecerDesde)
						/ (ref.alturaMax - ref.desvanecerDesde), 0, 1)
				end
				for _, par in ipairs(r.pares) do
					local o, c, capa = par[1], par[2], par[3]
					if o.Parent then
						local cf = espejo(o.CFrame, h) + capa.offset
						c.CFrame = cf
						-- más profundo bajo el piso = más tenue
						local prof = h - cf.Position.Y
						local fadeProf = 1 - math.clamp(prof / ref.desvanecerProfundidad, 0, 1)
						local visible = (1 - o.Transparency) * capa.opacidad * fadeProf * fadeAltura
						c.Transparency = 1 - visible
						for _, dc in ipairs(par[4]) do
							dc[1].Transparency = 1 - (1 - dc[2]) * visible
						end
					end
				end
			else
				for _, par in ipairs(r.pares) do
					par[2].Transparency = 1
					for _, dc in ipairs(par[4]) do dc[1].Transparency = 1 end
				end
			end
		end
	end
end)


-- reflejo del escenario: copias espejo de lo que hay cerca, borrosas, que se mueven con la cámara
do
	-- vista propia, sin el tinte café del reflejo del jugador, con la luz de la escena
	local vistaMundo = Instance.new("ViewportFrame")
	vistaMundo.Name = "VistaMundo"
	vistaMundo.BackgroundTransparency = 1
	vistaMundo.Size = UDim2.fromScale(1, 1)
	vistaMundo.ImageColor3 = Color3.new(1, 1, 1)
	vistaMundo.ZIndex = 0
	vistaMundo.Parent = gui
	local camMundo = Instance.new("Camera")
	camMundo.Parent = vistaMundo
	vistaMundo.CurrentCamera = camMundo
	local carpetaEscena = Instance.new("WorldModel")
	carpetaEscena.Name = "Escenario"
	carpetaEscena.Parent = vistaMundo
	local brilloPiso = 0
	RunService:BindToRenderStep("RF_ReflejoMundo", Enum.RenderPriority.Last.Value + 51, function()
		local cm = workspace.CurrentCamera
		if not cm then return end
		camMundo.CFrame = cm.CFrame
		camMundo.FieldOfView = cm.FieldOfView
		vistaMundo.Visible = ref.activado and ref.escenario
		vistaMundo.ImageTransparency = 1 - ref.escenaOpacidad * brilloPiso
	end)
	local copias = {} -- [parteOriginal] = { capas = {clon,...} }
	local alturaPiso
	local params = OverlapParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.RespectCanCollide = false

	local function quitar(o)
		local c = copias[o]
		if c then
			for _, x in ipairs(c.capas) do x:Destroy() end
			copias[o] = nil
		end
	end
	local function limpiarTodo()
		for o in pairs(copias) do quitar(o) end
	end

	local function sirve(p, h)
		if not p:IsA("BasePart") or p:IsA("Terrain") then return false end
		if p.Transparency > 0.6 or p.Name:sub(1, 4) == "GFX_" then return false end
		if p.Size.Magnitude > 260 then return false end
		local cf, size = p.CFrame, p.Size
		local medioY = math.abs(cf.UpVector.Y) * size.Y / 2 + math.abs(cf.RightVector.Y) * size.X / 2 + math.abs(cf.LookVector.Y) * size.Z / 2
		local abajoY, arribaY = cf.Position.Y - medioY, cf.Position.Y + medioY
		-- el propio piso no; solo lo que está parado encima
		if arribaY <= h + 0.3 then return false end
		if abajoY < h - 2 then return false end
		if esPersonaje(p) then return false end
		return true
	end

	local function hacerCopias(o)
		local ok, base = pcall(function()
			local a = o.Archivable
			o.Archivable = true
			local c = o:Clone()
			o.Archivable = a
			return c
		end)
		if not ok or not base then return end
		for _, d in ipairs(base:GetChildren()) do
			if not (d:IsA("DataModelMesh") or d:IsA("Decal") or d:IsA("Texture") or d:IsA("SurfaceAppearance")) then d:Destroy() end
		end
		base.Anchored = true
		base.CanCollide = false
		base.CanQuery = false
		base.CanTouch = false
		base.CastShadow = false
		local c = { capas = {} }
		for k = 1, ref.escenaCapas do
			local x = (k == 1) and base or base:Clone()
			x.Parent = carpetaEscena
			c.capas[k] = x
		end
		copias[o] = c
	end

	local function colocar(o, c, h)
		local espejado = espejo(o.CFrame, h)
		local n = ref.escenaCapas
		for k, x in ipairs(c.capas) do
			local t = (n > 1) and (k - 1) / (n - 1) or 0
			local ang = k * 2.39996
			local r = ref.escenaBorroso * 2.2 * t
			x.CFrame = espejado + Vector3.new(math.cos(ang) * r, -(k - 1) * ref.escenaBorroso * 0.4, math.sin(ang) * r)
			-- lo que está más alto se refleja más hondo y más tenue, como un reflejo real
			local hondo = h - x.Position.Y
			local fade = 1 - math.clamp(hondo / ref.escenaFade, 0, 1)
			x.Transparency = 1 - (1 - o.Transparency) * fade * (k == 1 and 1 or 0.45)
		end
	end

	local function refrescar()
		if not (ref.activado and ref.escenario) then limpiarTodo() return end
		local camara = workspace.CurrentCamera
		local foco = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		local centro = foco and foco.Position or (camara and camara.CFrame.Position)
		if not centro then return end
		local h = foco and pisoBajo(foco)
		if not h then limpiarTodo() alturaPiso = nil brilloPiso = 0 return end
		-- cuánto refleja el piso donde estás parado (pasto casi nada, plástico/metal bastante)
		local golpe = workspace:Raycast(foco.Position, Vector3.new(0, -60, 0), rayParams)
		if golpe then
			if golpe.Instance:IsA("Terrain") then
				brilloPiso = golpe.Material == Enum.Material.Water and 1 or 0.15
			else
				local mat = BRILLO_MATERIAL[golpe.Instance.Material.Name] or 0.7
				brilloPiso = math.clamp(golpe.Instance.Reflectance * 1.6 + mat * 0.45, 0, 1)
			end
		end
		local sd = Lighting:GetSunDirection()
		vistaMundo.LightDirection = Vector3.new(-sd.X, sd.Y, -sd.Z)
		vistaMundo.Ambient = Lighting.OutdoorAmbient:Lerp(Color3.new(1, 1, 1), 0.25)
		vistaMundo.LightColor = Color3.new(1, 1, 1):Lerp(Lighting.OutdoorAmbient, 0.3)
		if alturaPiso and math.abs(alturaPiso - h) > 0.5 then limpiarTodo() end
		alturaPiso = h

		local excluir = { workspace.Terrain }
		for _, pl in ipairs(Players:GetPlayers()) do
			if pl.Character then table.insert(excluir, pl.Character) end
		end
		for _, nombre in ipairs({ "GFX_Lluvia", "GFX_Extras", "GFX_Aurora", "GFX_Rayos" }) do
			local f = workspace:FindFirstChild(nombre)
			if f then table.insert(excluir, f) end
		end
		params.FilterDescendantsInstances = excluir
		local cerca = workspace:GetPartBoundsInRadius(centro, ref.escenaRadio, params)
		local lista = {}
		for _, p in ipairs(cerca) do
			if sirve(p, h) then table.insert(lista, p) end
		end
		table.sort(lista, function(a, b) return (a.Position - centro).Magnitude < (b.Position - centro).Magnitude end)
		local quedan = {}
		for i = 1, math.min(#lista, ref.escenaMax) do
			local p = lista[i]
			quedan[p] = true
			if not copias[p] then hacerCopias(p) end
			local c = copias[p]
			if c then colocar(p, c, h) end
		end
		for o in pairs(copias) do
			if not quedan[o] or not o.Parent then quitar(o) end
		end
	end

	task.spawn(function()
		while true do
			local ok, err = pcall(refrescar)
			if not ok then warn("[4Phant0nmnn] " .. tostring(err)) end
			task.wait(0.35)
		end
	end)
end

local GOTA_TEXTURA = "rbxasset://textures/particles/smoke_main.dds"
local CELDA, LADO = 8, 13
local ALTO_LLUVIA = 60

local carpetaLluvia = Instance.new("Folder")
carpetaLluvia.Name = "GFX_Lluvia"
carpetaLluvia.Parent = workspace

local celdas = {}
for i = 1, LADO * LADO do
	local p = Instance.new("Part")
	p.Name = "Celda"
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.CastShadow = false
	p.Transparency = 1
	p.Size = Vector3.new(CELDA, 0.2, CELDA)
	local e = Instance.new("ParticleEmitter")
	e.Texture = GOTA_TEXTURA
	e.Shape = Enum.ParticleEmitterShape.Box
	e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	e.EmissionDirection = Enum.NormalId.Bottom
	e.Orientation = Enum.ParticleOrientation.VelocityParallel
	e.SpreadAngle = Vector2.new(2, 2)
	e.Size = NumberSequence.new(0.14, 0.12)
	e.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.32),
		NumberSequenceKeypoint.new(0.9, 0.4),
		NumberSequenceKeypoint.new(1, 1),
	})
	e.Color = ColorSequence.new(Color3.fromRGB(222, 230, 245))
	e.LightEmission = 0.4
	e.LightInfluence = 0.5
	e.Enabled = false
	e.Parent = p
	p.Parent = carpetaLluvia
	celdas[i] = { p, e }
end

local ancla = Instance.new("Part")
ancla.Name = "GFX_Salpicaduras"
ancla.Anchored = true
ancla.CanCollide = false
ancla.CanQuery = false
ancla.CanTouch = false
ancla.Transparency = 1
ancla.Size = Vector3.new(0.2, 0.2, 0.2)
ancla.Parent = carpetaLluvia
local punto = Instance.new("Attachment")
punto.Parent = ancla

local gotitas = Instance.new("ParticleEmitter")
gotitas.Enabled = false
gotitas.Rate = 0
gotitas.Texture = GOTA_TEXTURA
gotitas.EmissionDirection = Enum.NormalId.Top
gotitas.SpreadAngle = Vector2.new(50, 50)
gotitas.Speed = NumberRange.new(6, 13)
gotitas.Acceleration = Vector3.new(0, -80, 0)
gotitas.Lifetime = NumberRange.new(0.18, 0.35)
gotitas.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 0.04) })
gotitas.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(1, 1) })
gotitas.Color = ColorSequence.new(Color3.fromRGB(228, 236, 250))
gotitas.LightEmission = 0.45

local corona = Instance.new("ParticleEmitter")
corona.Enabled = false
corona.Rate = 0
corona.Texture = "rbxasset://textures/particles/smoke_main.dds"
corona.EmissionDirection = Enum.NormalId.Top
corona.Orientation = Enum.ParticleOrientation.VelocityParallel
corona.SpreadAngle = Vector2.new(65, 65)
corona.Speed = NumberRange.new(9, 16)
corona.Acceleration = Vector3.new(0, -90, 0)
corona.Lifetime = NumberRange.new(0.1, 0.2)
corona.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.07), NumberSequenceKeypoint.new(1, 0.03) })
corona.Squash = NumberSequence.new(1.6)
corona.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1) })
corona.Color = ColorSequence.new(Color3.fromRGB(232, 240, 252))
corona.LightEmission = 0.5
gotitas.Parent = punto
corona.Parent = punto

local anillo = Instance.new("ParticleEmitter")
anillo.Enabled = false
anillo.Rate = 0
anillo.Texture = GOTA_TEXTURA
anillo.EmissionDirection = Enum.NormalId.Top
anillo.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
anillo.Speed = NumberRange.new(0.01)
anillo.Lifetime = NumberRange.new(0.25, 0.45)
anillo.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1.4) })
anillo.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.28), NumberSequenceKeypoint.new(1, 1) })
anillo.Color = ColorSequence.new(Color3.fromRGB(215, 226, 242))
anillo.LightEmission = 0.3
anillo.Parent = punto

local niebla = Instance.new("ParticleEmitter")
niebla.Enabled = false
niebla.Rate = 0
niebla.Texture = GOTA_TEXTURA
niebla.EmissionDirection = Enum.NormalId.Top
niebla.Speed = NumberRange.new(0.5, 1.5)
niebla.Lifetime = NumberRange.new(0.3, 0.5)
niebla.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.6) })
niebla.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 1) })
niebla.Color = ColorSequence.new(Color3.fromRGB(215, 222, 235))
niebla.Parent = punto

local rayoLluvia = RaycastParams.new()
rayoLluvia.FilterType = Enum.RaycastFilterType.Exclude
rayoLluvia.FilterDescendantsInstances = { carpetaLluvia }
rayoLluvia.IgnoreWater = false

local function superficieDir(origen, dir, largo)
	local hit = workspace:Raycast(origen, dir * largo, rayoLluvia)
	local n = 0
	while hit and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain") and hit.Instance.Transparency >= 0.95 and n < 3 do
		n += 1
		hit = workspace:Raycast(hit.Position + dir * 0.05, dir * largo, rayoLluvia)
	end
	return hit
end

local function cajaHacia(pos, dir)
	local arriba = -dir
	local derecha = arriba:Cross(Vector3.zAxis)
	if derecha.Magnitude < 1e-3 then derecha = Vector3.xAxis end
	return CFrame.fromMatrix(pos, derecha.Unit, arriba)
end

local function superficieBajo(x, y, z, largo)
	local hit = workspace:Raycast(Vector3.new(x, y, z), Vector3.new(0, -largo, 0), rayoLluvia)
	-- saltar partes invisibles (zonas, hitboxes)
	local n = 0
	while hit and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain") and hit.Instance.Transparency >= 0.95 and n < 3 do
		n += 1
		hit = workspace:Raycast(hit.Position - Vector3.new(0, 0.05, 0), Vector3.new(0, -largo, 0), rayoLluvia)
	end
	return hit
end

local vientoActual = 0
local rafaga, rafagaObjetivo = 0, 0
RunService.Heartbeat:Connect(function(dt)
	local base = gfx.lluviaViento
	if gfx.tormenta then
		if math.random() < dt * 0.25 then
			rafagaObjetivo = (0.5 + math.random()) * gfx.tormentaRafagas
		end
		rafagaObjetivo = math.max(rafagaObjetivo - dt * 0.18, 0)
		rafaga += (rafagaObjetivo - rafaga) * math.min(dt * 2.5, 1)
		local t = os.clock()
		vientoActual = base * (1 + 0.35 * math.sin(t * 0.37) + 0.15 * math.sin(t * 1.3) + rafaga)
	elseif gfx.lluvia then
		vientoActual = base
	else
		local t = os.clock()
		vientoActual = gfx.brisa * 14 * (1 + 0.3 * math.sin(t * 0.5) + 0.2 * math.sin(t * 1.7) + 0.15 * math.sin(t * 3.1))
	end
end)

local function vectorLluvia()
	local w = vientoActual * 2.4
	return Vector3.new(w, -gfx.lluviaVelocidad, w * 0.35)
end

local function actualizarCeldas()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local c = cam.CFrame.Position
	local arriba = c.Y + ALTO_LLUVIA
	local v = vectorLluvia()
	local rapidez = v.Magnitude
	local dir = v.Unit
	-- las gotas lleguen alrededor de la cámara
	local inclinacion = Vector3.new(v.X, 0, v.Z) / -v.Y
	local corrido = inclinacion * ALTO_LLUVIA
	local cx = math.floor((c.X - corrido.X) / CELDA) * CELDA
	local cz = math.floor((c.Z - corrido.Z) / CELDA) * CELDA
	local mitad = (LADO - 1) / 2
	local rate = gfx.lluviaIntensidad / (LADO * LADO)
	if gfx.tormenta then rate *= (0.85 + rafaga * 0.5) end
	local largoMax = (ALTO_LLUVIA + 300) / math.max(-dir.Y, 0.2)
	local i = 0
	for gx = -mitad, mitad do
		for gz = -mitad, mitad do
			i += 1
			local celda = celdas[i]
			local origen = Vector3.new(cx + gx * CELDA + CELDA / 2, arriba, cz + gz * CELDA + CELDA / 2)
			celda[1].CFrame = cajaHacia(origen, dir)
			local hit = superficieDir(origen, dir, largoMax)
			local distancia = hit and (hit.Position - origen).Magnitude or largoMax
			local vida = math.max(distancia / (rapidez * 1.02), 0.02)
			local e = celda[2]
			e.Lifetime = NumberRange.new(vida * 0.97, vida)
			e.Speed = NumberRange.new(rapidez * 0.96, rapidez * 1.02)
			e.Rate = rate
			e.Acceleration = Vector3.zero
			e.Squash = NumberSequence.new(gfx.lluviaEstirar)
			e.Enabled = true
		end
	end
end

local function apagarCeldas()
	for _, c in ipairs(celdas) do c[2].Enabled = false end
end

local acumulado = 0
RunService.Heartbeat:Connect(function(dt)
	if not gfx.lluvia then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	acumulado += gfx.lluviaSalpicaduras * dt
	local n = math.min(math.floor(acumulado), 70)
	acumulado -= n
	local c = cam.CFrame.Position
	local v = vectorLluvia()
	local dir = v.Unit
	local inclinacion = Vector3.new(v.X, 0, v.Z) / -v.Y
	local largo = (ALTO_LLUVIA + 300) / math.max(-dir.Y, 0.2)
	local empuje = Vector3.new(v.X, 0, v.Z) * 0.35
	gotitas.Acceleration = Vector3.new(empuje.X, -80, empuje.Z)
	corona.Acceleration = Vector3.new(empuje.X, -90, empuje.Z)
	niebla.Acceleration = empuje * 0.5
	for _ = 1, n do
		-- más impactos cerca de la cámara (donde se notan)
		local r = 55 * math.sqrt(math.random())
		local a = math.random() * math.pi * 2
		local destino = Vector3.new(c.X + math.cos(a) * r, c.Y, c.Z + math.sin(a) * r)
		local origen = destino + Vector3.new(0, ALTO_LLUVIA, 0) - inclinacion * ALTO_LLUVIA
		local hit = superficieDir(origen, dir, largo)
		if hit then
			local up = hit.Normal
			local pos = hit.Position + up * 0.05
			local eje = Vector3.yAxis:Cross(up)
			if eje.Magnitude < 1e-3 then
				punto.WorldCFrame = CFrame.new(pos)
			else
				punto.WorldCFrame = CFrame.new(pos) * CFrame.fromAxisAngle(eje.Unit, math.acos(math.clamp(up.Y, -1, 1)))
			end
			gotitas:Emit(math.random(3, 6))
			corona:Emit(math.random(3, 5))
			anillo:Emit(1)
			if math.random() < 0.35 then niebla:Emit(1) end
		end
	end
end)

local relojCeldas = 0
RunService.Heartbeat:Connect(function(dt)
	if not gfx.lluvia then return end
	relojCeldas += dt
	if relojCeldas >= 0.15 then
		relojCeldas = 0
		actualizarCeldas()
	end
end)

local flash = Instance.new("ColorCorrectionEffect")
flash.Name = "GFX_Relampago"
flash.Parent = Lighting

local carpetaRayos = Instance.new("Folder")
carpetaRayos.Name = "GFX_Rayos"
carpetaRayos.Parent = workspace

local VEL_SONIDO = 1225

do
local cortinas = Instance.new("ParticleEmitter")
cortinas.Texture = GOTA_TEXTURA
cortinas.Shape = Enum.ParticleEmitterShape.Box
cortinas.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
cortinas.Lifetime = NumberRange.new(3, 5)
cortinas.Speed = NumberRange.new(0)
cortinas.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 18), NumberSequenceKeypoint.new(1, 34) })
cortinas.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.3, 0.9),
	NumberSequenceKeypoint.new(0.7, 0.9),
	NumberSequenceKeypoint.new(1, 1),
})
cortinas.Color = ColorSequence.new(Color3.fromRGB(175, 182, 195))
cortinas.LightInfluence = 1
cortinas.Rotation = NumberRange.new(0, 360)
cortinas.Enabled = false
local cajaCortinas = Instance.new("Part")
cajaCortinas.Name = "Cortinas"
cajaCortinas.Anchored = true
cajaCortinas.CanCollide = false
cajaCortinas.CanQuery = false
cajaCortinas.CanTouch = false
cajaCortinas.Transparency = 1
cajaCortinas.Size = Vector3.new(160, 30, 160)
cortinas.Parent = cajaCortinas
cajaCortinas.Parent = carpetaLluvia

local sonidoLluvia = Instance.new("Sound")
sonidoLluvia.Name = "GFX_SonidoLluvia"
sonidoLluvia.Looped = true
sonidoLluvia.Volume = 0.5
sonidoLluvia.Parent = workspace.CurrentCamera or workspace

RunService.Heartbeat:Connect(function()
	local cam = workspace.CurrentCamera
	local activa = gfx.lluvia and gfx.tormenta and cam ~= nil
	cortinas.Enabled = activa and gfx.tormentaCortinas > 0
	if activa then
		cortinas.Rate = gfx.tormentaCortinas
		cortinas.Acceleration = Vector3.new(vientoActual * 1.4, -2, vientoActual * 0.5)
		cajaCortinas.CFrame = CFrame.new(cam.CFrame.Position + Vector3.new(-vientoActual * 1.5, 6, 0))
	end
	local quiereSonido = gfx.lluvia and gfx.lluviaSonido ~= ""
	if quiereSonido then
		if sonidoLluvia.SoundId ~= gfx.lluviaSonido then sonidoLluvia.SoundId = gfx.lluviaSonido end
		sonidoLluvia.Volume = gfx.tormenta and 0.8 or 0.45
		if not sonidoLluvia.IsPlaying then sonidoLluvia:Play() end
	elseif sonidoLluvia.IsPlaying then
		sonidoLluvia:Stop()
	end
end)

local function emisorCaja(nombre, size)
	local p = Instance.new("Part")
	p.Name = nombre
	p.Anchored = true
	p.CanCollide = false
	p.CanQuery = false
	p.CanTouch = false
	p.Transparency = 1
	p.Size = size
	p.Parent = carpetaLluvia
	local e = Instance.new("ParticleEmitter")
	e.Shape = Enum.ParticleEmitterShape.Box
	e.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	e.Enabled = false
	e.Parent = p
	return p, e
end

local cajaCerca, gotasCerca = emisorCaja("GotasCerca", Vector3.new(38, 0.2, 38))
gotasCerca.Texture = GOTA_TEXTURA
gotasCerca.EmissionDirection = Enum.NormalId.Bottom
gotasCerca.Orientation = Enum.ParticleOrientation.VelocityParallel
gotasCerca.SpreadAngle = Vector2.new(3, 3)
gotasCerca.Size = NumberSequence.new(0.17, 0.15)
gotasCerca.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.25),
	NumberSequenceKeypoint.new(0.85, 0.35),
	NumberSequenceKeypoint.new(1, 1),
})
gotasCerca.Color = ColorSequence.new(Color3.fromRGB(230, 236, 248))
gotasCerca.LightEmission = 0.45
gotasCerca.LightInfluence = 0.45

local cajaNeblina, neblinaSuelo = emisorCaja("NeblinaSuelo", Vector3.new(130, 2, 130))
neblinaSuelo.Texture = GOTA_TEXTURA
neblinaSuelo.Lifetime = NumberRange.new(4, 6)
neblinaSuelo.Speed = NumberRange.new(0)
neblinaSuelo.Rotation = NumberRange.new(0, 360)
neblinaSuelo.RotSpeed = NumberRange.new(-6, 6)
neblinaSuelo.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 9), NumberSequenceKeypoint.new(1, 18) })
neblinaSuelo.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.35, 0.86),
	NumberSequenceKeypoint.new(0.7, 0.86),
	NumberSequenceKeypoint.new(1, 1),
})
neblinaSuelo.Color = ColorSequence.new(Color3.fromRGB(205, 210, 220))
neblinaSuelo.LightInfluence = 1

local cajaEscombros, escombros = emisorCaja("Escombros", Vector3.new(120, 14, 120))
escombros.Lifetime = NumberRange.new(2, 3.5)
escombros.Speed = NumberRange.new(0)
escombros.Rotation = NumberRange.new(0, 360)
escombros.RotSpeed = NumberRange.new(-400, 400)
escombros.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.18), NumberSequenceKeypoint.new(1, 0.3) })
escombros.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(0.85, 0.1), NumberSequenceKeypoint.new(1, 1) })
escombros.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 82, 40)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(95, 70, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 55)),
})
escombros.LightInfluence = 1

local rayoArriba = RaycastParams.new()
rayoArriba.FilterType = Enum.RaycastFilterType.Exclude
local cieloAbierto = true
local relojAbierto = 0

RunService.Heartbeat:Connect(function(dt)
	local cam = workspace.CurrentCamera
	local llueve = gfx.lluvia and cam ~= nil
	if not llueve then
		gotasCerca.Enabled = false
		neblinaSuelo.Enabled = false
		escombros.Enabled = false
		return
	end
	local c = cam.CFrame.Position
	relojAbierto += dt
	if relojAbierto > 0.2 then
		relojAbierto = 0
		local excluir = { carpetaLluvia, carpetaRayos }
		if player.Character then table.insert(excluir, player.Character) end
		rayoArriba.FilterDescendantsInstances = excluir
		cieloAbierto = workspace:Raycast(c, Vector3.new(0, 60, 0), rayoArriba) == nil
	end
	local viento = vientoActual

	gotasCerca.Enabled = cieloAbierto and gfx.lluviaCerca > 0
	if gotasCerca.Enabled then
		local alto = 18
		local v = vectorLluvia()
		local rapidez = v.Magnitude
		local dir = v.Unit
		local inclinacion = Vector3.new(v.X, 0, v.Z) / -v.Y
		local origen = c + Vector3.new(0, alto, 0) - inclinacion * alto
		cajaCerca.CFrame = cajaHacia(origen, dir)
		local largo = (alto + 60) / math.max(-dir.Y, 0.2)
		local hit = superficieDir(origen, dir, largo)
		local distancia = hit and (hit.Position - origen).Magnitude or largo
		local vida = math.clamp(distancia / (rapidez * 1.03), 0.05, 1.2)
		gotasCerca.Lifetime = NumberRange.new(vida * 0.95, vida)
		gotasCerca.Speed = NumberRange.new(rapidez * 0.95, rapidez * 1.03)
		gotasCerca.Rate = gfx.lluviaCerca * (gfx.tormenta and (0.9 + rafaga * 0.6) or 1)
		gotasCerca.Acceleration = Vector3.zero
		gotasCerca.Squash = NumberSequence.new(gfx.lluviaEstirar + 0.4)
	end

	-- neblina del suelo
	neblinaSuelo.Enabled = gfx.lluviaNeblinaSuelo > 0
	if neblinaSuelo.Enabled then
		local hit = superficieBajo(c.X, c.Y + 5, c.Z, 300)
		local y = hit and hit.Position.Y or (c.Y - 6)
		cajaNeblina.CFrame = CFrame.new(c.X, y + 1.5, c.Z)
		neblinaSuelo.Rate = gfx.lluviaNeblinaSuelo * (gfx.tormenta and 1.6 or 1)
		neblinaSuelo.Acceleration = Vector3.new(viento * 0.25, 0, viento * 0.1)
	end

	-- escombros con el viento
	escombros.Enabled = gfx.tormenta and gfx.tormentaEscombros > 0
	if escombros.Enabled then
		cajaEscombros.CFrame = CFrame.new(c + Vector3.new(-viento * 1.2, 2, 0))
		escombros.Rate = gfx.tormentaEscombros * (0.6 + rafaga)
		escombros.Acceleration = Vector3.new(viento * 2.2, -4 + rafaga * 6, viento * 0.7)
	end
end)

local lenteGui = Instance.new("ScreenGui")
lenteGui.Name = "GFX_GotasLente"
lenteGui.IgnoreGuiInset = true
lenteGui.ResetOnSpawn = false
lenteGui.DisplayOrder = -998
lenteGui.Parent = player:WaitForChild("PlayerGui")
local gotasEnLente = 0
local relojLente = 0

local function gotaLente()
	gotasEnLente += 1
	local tam = math.random(10, 30)
	local g = Instance.new("Frame")
	g.AnchorPoint = Vector2.new(0.5, 0.5)
	g.Position = UDim2.fromScale(math.random(), math.random() * 0.85)
	g.Size = UDim2.fromOffset(tam, tam * (1 + math.random() * 0.25))
	g.BackgroundColor3 = Color3.fromRGB(235, 242, 255)
	g.BackgroundTransparency = 0.88
	g.BorderSizePixel = 0
	local cr = Instance.new("UICorner")
	cr.CornerRadius = UDim.new(1, 0)
	cr.Parent = g
	local st = Instance.new("UIStroke")
	st.Color = Color3.fromRGB(255, 255, 255)
	st.Transparency = 0.62
	st.Thickness = 1
	st.Parent = g
	local brillo = Instance.new("UIGradient")
	brillo.Rotation = 120
	brillo.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.35, 0.7),
		NumberSequenceKeypoint.new(1, 0.3),
	})
	brillo.Parent = g
	g.Parent = lenteGui
	local vida = 1.2 + math.random() * 1.6
	local baja = math.random(10, 140)
	TweenService:Create(g, TweenInfo.new(vida, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = g.Position + UDim2.fromOffset(0, baja),
		Size = UDim2.fromOffset(tam * 0.8, tam * (1.2 + baja / 120)),
		BackgroundTransparency = 1,
	}):Play()
	TweenService:Create(st, TweenInfo.new(vida), { Transparency = 1 }):Play()
	task.delay(vida, function()
		g:Destroy()
		gotasEnLente -= 1
	end)
end

RunService.RenderStepped:Connect(function(dt)
	local cam = workspace.CurrentCamera
	if not (gfx.lluvia and gfx.lluviaLente and cam and cieloAbierto) then return end
	if cam.CFrame.LookVector.Y < -0.45 then return end
	relojLente += dt
	local cada = gfx.tormenta and 0.06 or 0.14
	while relojLente > cada do
		relojLente -= cada
		if gotasEnLente < (gfx.tormenta and 45 or 25) then gotaLente() end
	end
end)

end

do
	local vientoOriginal = workspace.GlobalWind

	local plantas = {}
	local registradas = setmetatable({}, { __mode = "k" })
	local function esPlanta(p)
		if not p:IsA("BasePart") or p:IsA("Terrain") or registradas[p] then return false end
		if not p.Anchored then return false end
		if p.Size.Magnitude > 30 then return false end
		local nombre = string.lower(p.Name)
		local padre = p.Parent and string.lower(p.Parent.Name) or ""
		for _, clave in ipairs(gfx.pastoNombres) do
			if string.find(nombre, clave, 1, true) or string.find(padre, clave, 1, true) then
				return true
			end
		end
		return false
	end
	local function registrar(p)
		if not esPlanta(p) then return end
		local m = p:FindFirstAncestorOfClass("Model")
		if m and m:FindFirstChildOfClass("Humanoid") then return end
		registradas[p] = true
		table.insert(plantas, { p, p.CFrame, math.random() * math.pi * 2, 0.7 + math.random() * 0.6 })
	end
	task.spawn(function()
		for i, d in ipairs(workspace:GetDescendants()) do
			registrar(d)
			if i % 2000 == 0 then task.wait() end
		end
	end)
	workspace.DescendantAdded:Connect(function(d)
		if d:IsA("BasePart") then task.defer(registrar, d) end
	end)

	local cerca = {}
	local relojCerca = 0
	local movidas = {}
	local listaP, listaCF = {}, {}
	local fuerzaSuave = 0

	RunService.Heartbeat:Connect(function(dt)
		local cam = workspace.CurrentCamera
		if not cam then return end
		-- cuánto viento hay ahora
		local hayViento = gfx.pastoViento and (gfx.lluvia or gfx.brisa > 0)
		local w = hayViento and vientoActual or 0
		local objetivo = hayViento and math.clamp(math.abs(w) / 30, 0, 1.6) * gfx.pastoFuerza or 0
		fuerzaSuave += (objetivo - fuerzaSuave) * math.min(dt * 3, 1)

		-- viento global (pasto de Terrain, nubes)
		pcall(function()
			if hayViento then
				workspace.GlobalWind = Vector3.new(w * 1.8, 0, w * 0.6) * gfx.pastoFuerza
			elseif workspace.GlobalWind ~= vientoOriginal then
				workspace.GlobalWind = vientoOriginal
			end
		end)

		-- lista de plantas cercanas (cada 0.5 s)
		relojCerca += dt
		if relojCerca > 0.5 then
			relojCerca = 0
			table.clear(cerca)
			local c = cam.CFrame.Position
			for _, pl in ipairs(plantas) do
				if pl[1].Parent and (pl[2].Position - c).Magnitude < 160 then
					table.insert(cerca, pl)
					if #cerca >= 1500 then break end
				end
			end
		end

		table.clear(listaP)
		table.clear(listaCF)
		if fuerzaSuave > 0.01 then
			local dirViento = Vector3.new(w, 0, w * 0.35)
			if dirViento.Magnitude < 1e-3 then dirViento = Vector3.xAxis end
			dirViento = dirViento.Unit
			local eje = Vector3.yAxis:Cross(dirViento)
			local t = os.clock()
			local golpe = (rafaga or 0)
			for _, pl in ipairs(cerca) do
				local p, cf0, fase, rigidez = pl[1], pl[2], pl[3], pl[4]
				local vaiven = math.sin(t * (2.2 + rigidez) + fase) * 0.45 + math.sin(t * 5.3 + fase * 2) * 0.15
				local grados = (12 + 10 * golpe) * fuerzaSuave * (0.75 + vaiven) * rigidez
				local base = cf0 * CFrame.new(0, -p.Size.Y / 2, 0)
				local giro = CFrame.fromAxisAngle(eje, math.rad(grados))
				local nuevo = CFrame.new(base.Position) * giro * CFrame.new(-base.Position) * cf0
				table.insert(listaP, p)
				table.insert(listaCF, nuevo)
				movidas[p] = cf0
			end
		elseif next(movidas) then
			-- sin viento: todo vuelve a su lugar
			for p, cf0 in pairs(movidas) do
				if p.Parent then
					table.insert(listaP, p)
					table.insert(listaCF, cf0)
				end
			end
			table.clear(movidas)
		end
		if #listaP > 0 then
			workspace:BulkMoveTo(listaP, listaCF, Enum.BulkMoveMode.FireCFrameChanged)
		end
	end)
end

-- temblor de cámara (se suma después de tu cámara)
local temblor = 0
RunService:BindToRenderStep("GFX_Temblor", Enum.RenderPriority.Last.Value + 5, function(dt)
	if temblor > 0.001 then
		local cam = workspace.CurrentCamera
		local a = temblor
		cam.CFrame = cam.CFrame * CFrame.Angles(
			math.rad((math.random() - 0.5) * a), math.rad((math.random() - 0.5) * a), 0)
		temblor = math.max(temblor - dt * 2.2, 0)
	end
end)

local function dibujarRayo(desde, hasta, grosor, padre, profundidad, luces)
	local partes = {}
	local pasos = math.max(math.floor((desde - hasta).Magnitude / 24), 4)
	local prev = desde
	for i = 1, pasos do
		local t = i / pasos
		local objetivo = desde:Lerp(hasta, t)
		local desvio = (i < pasos) and Vector3.new((math.random() - 0.5) * 34, 0, (math.random() - 0.5) * 34) or Vector3.zero
		local punto = objetivo + desvio
		local largo = (punto - prev).Magnitude
		local cf = CFrame.lookAt((prev + punto) / 2, punto)
		local p = Instance.new("Part")
		p.Anchored = true
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.CastShadow = false
		p.Material = Enum.Material.Neon
		p.Color = Color3.fromRGB(255, 255, 255)
		p.Size = Vector3.new(grosor, grosor, largo + grosor * 0.5)
		p.CFrame = cf
		p:SetAttribute("T0", 0)
		p.Parent = padre
		table.insert(partes, p)
		-- halo: más grueso, azulado y translúcido
		local h = Instance.new("Part")
		h.Anchored = true
		h.CanCollide = false
		h.CanQuery = false
		h.CanTouch = false
		h.CastShadow = false
		h.Material = Enum.Material.Neon
		h.Color = Color3.fromRGB(150, 180, 255)
		h.Size = Vector3.new(grosor * 3.2, grosor * 3.2, largo + grosor * 2)
		h.CFrame = cf
		h:SetAttribute("T0", 0.62)
		h.Parent = padre
		table.insert(partes, h)
		if luces and profundidad == 0 and i % 3 == 0 then
			local l = Instance.new("PointLight")
			l.Range = 60
			l.Brightness = 0
			l.Color = Color3.fromRGB(210, 225, 255)
			l.Shadows = false
			l.Parent = p
			table.insert(luces, l)
		end
		-- ramas que se abren hacia abajo
		if profundidad < 2 and math.random() < 0.3 and i < pasos - 1 then
			local dir = Vector3.new((math.random() - 0.5) * 2, -1.2, (math.random() - 0.5) * 2).Unit
			local largoRama = (desde - hasta).Magnitude * (0.15 + math.random() * 0.25)
			for _, q in ipairs(dibujarRayo(punto, punto + dir * largoRama, grosor * 0.55, padre, profundidad + 1, luces)) do
				table.insert(partes, q)
			end
		end
		prev = punto
	end
	return partes
end

local function verRayo(partes, luces, v)
	for _, p in ipairs(partes) do
		local t0 = p:GetAttribute("T0") or 0
		p.Transparency = 1 - (1 - t0) * v
	end
	for _, l in ipairs(luces) do l.Brightness = 9 * v end
end

local function nubesDestello(intensidad)
	local nubes = workspace.Terrain:FindFirstChildOfClass("Clouds")
	if not nubes then return end
	local base = gfx.noche and Color3.fromRGB(30, 33, 40) or Color3.fromRGB(78, 82, 92)
	if not gfx.tormenta then
		base = gfx.noche and Color3.fromRGB(30, 33, 40) or Color3.fromRGB(95, 100, 110)
	end
	nubes.Color = base:Lerp(Color3.fromRGB(235, 240, 255), intensidad)
	task.delay(0.07, function() nubes.Color = base end)
end

local function destello(brillo)
	flash.Brightness = brillo
	flash.TintColor = Color3.fromRGB(225, 232, 255)
	flash.Contrast = -0.05
end
local function apagarDestello()
	flash.Brightness = 0
	flash.TintColor = Color3.new(1, 1, 1)
	flash.Contrast = 0
end

local function trueno(distancia)
	task.delay(distancia / VEL_SONIDO, function()
		if gfx.tormentaTemblor and distancia < 450 then
			temblor = math.max(temblor, 1.6 * (1 - distancia / 450))
		end
		if gfx.truenoSonido ~= "" then
			local snd = Instance.new("Sound")
			snd.SoundId = gfx.truenoSonido
			snd.Volume = math.clamp(1.6 - distancia / 900, 0.25, 1.4)
			snd.PlaybackSpeed = 0.85 + math.random() * 0.25
			snd.Parent = workspace.CurrentCamera
			snd:Play()
			snd.Ended:Connect(function() snd:Destroy() end)
			task.delay(15, function() if snd.Parent then snd:Destroy() end end)
		end
	end)
end

local function rayo()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local c = cam.CFrame.Position
	local aTierra = math.random() < gfx.tormentaATierra
	local distancia = 110 + math.random() * 420
	local mira = cam.CFrame.LookVector
	local base = math.atan2(mira.Z, mira.X)
	local ang = base + (math.random() - 0.5) * math.rad(150)
	local x, z = c.X + math.cos(ang) * distancia, c.Z + math.sin(ang) * distancia
	local cercania = math.clamp(1.25 - distancia / 600, 0.35, 1)

	local partes, suelo, luces = {}, nil, {}
	if aTierra then
		local hit = superficieBajo(x, c.Y + 900, z, 2000)
		suelo = hit and hit.Position or Vector3.new(x, c.Y - 20, z)
		local cielo = Vector3.new(x + (math.random() - 0.5) * 120, c.Y + 380 + math.random() * 120, z + (math.random() - 0.5) * 120)
		local grosor = math.clamp(distancia / 150, 1.8, 4.2)
		partes = dibujarRayo(cielo, suelo, grosor, carpetaRayos, 0, luces)
		-- ordenar de arriba a abajo para que la guía baje
		table.sort(partes, function(p1, p2) return p1.Position.Y > p2.Position.Y end)
		verRayo(partes, luces, 0)
		local n = #partes
		local porPaso = math.max(1, math.floor(n / 7))
		for i = 1, n, porPaso do
			for j = i, math.min(i + porPaso - 1, n) do
				local t0 = partes[j]:GetAttribute("T0") or 0
				partes[j].Transparency = 1 - (1 - t0) * 0.45
			end
			nubesDestello(0.15)
			task.wait(0.02)
		end
	end

	local foco
	if suelo and distancia < 380 then
		foco = Instance.new("Part")
		foco.Anchored = true
		foco.CanCollide = false
		foco.CanQuery = false
		foco.CanTouch = false
		foco.Transparency = 1
		foco.Size = Vector3.new(1, 1, 1)
		foco.CFrame = CFrame.new(suelo + Vector3.new(0, 12, 0))
		local luz = Instance.new("PointLight")
		luz.Range = 60
		luz.Brightness = 0
		luz.Color = Color3.fromRGB(205, 220, 255)
		luz.Shadows = true
		luz.Parent = foco
		foco.Parent = carpetaRayos
	end

	local golpes = math.random(2, 4)
	for g = 1, golpes do
		local fuerza = (aTierra and 0.85 or 0.45) * (g == 1 and 1 or (0.45 + math.random() * 0.45)) * cercania
		destello(fuerza)
		nubesDestello(aTierra and 0.9 or 0.6)
		verRayo(partes, luces, 1)
		if foco then foco.PointLight.Brightness = 12 * fuerza end
		task.wait(0.05 + math.random() * 0.05)
		apagarDestello()
		verRayo(partes, luces, 0.35)
		if foco then foco.PointLight.Brightness = 2 end
		task.wait(0.03 + math.random() * 0.1)
	end
	for i = 1, 8 do
		verRayo(partes, luces, 0.35 * (1 - i / 8))
		if foco then foco.PointLight.Brightness = math.max(2 - i * 0.3, 0) end
		task.wait(0.035)
	end
	for _, p in ipairs(partes) do p:Destroy() end
	if foco then foco:Destroy() end
	trueno(distancia)
end

task.spawn(function()
	local proximoRayo, proximoDestello = 0, os.clock() + math.random(6, 15)
	while true do
		task.wait(0.25)
		local ahora = os.clock()
		if gfx.lluvia and gfx.tormenta then
			if ahora >= proximoRayo then
				task.spawn(rayo)
				local minimo = math.max(gfx.tormentaRayosMin, 0.5)
				local maximo = math.max(gfx.tormentaRayosMax, minimo)
				proximoRayo = ahora + minimo + math.random() * (maximo - minimo)
			end
		else
			proximoRayo = ahora + 1
			if gfx.lluvia and gfx.relampagos and ahora >= proximoDestello then
				task.spawn(function()
					for _, b in ipairs({ 0.4, 0.12, 0.28 }) do
						destello(b)
						nubesDestello(0.5)
						task.wait(0.05)
						apagarDestello()
						task.wait(math.random() * 0.12)
					end
				end)
				proximoDestello = ahora + math.random(9, 26)
			end
		end
	end
end)

local function actualizarLluvia()
	if gfx.lluvia then
		actualizarCeldas()
	else
		apagarCeldas()
	end
	aplicarGraficos()
	actualizarSuperficies()
end

local actualizarNoche
do
local portaLuz = Instance.new("Part")
portaLuz.Name = "GFX_Linterna"
portaLuz.Anchored = true
portaLuz.CanCollide = false
portaLuz.CanQuery = false
portaLuz.CanTouch = false
portaLuz.Transparency = 1
portaLuz.Size = Vector3.new(0.2, 0.2, 0.2)
portaLuz.Parent = workspace

local linterna = Instance.new("SpotLight")
linterna.Face = Enum.NormalId.Front
linterna.Angle = 50
linterna.Range = 60
linterna.Brightness = 2.2
linterna.Color = Color3.fromRGB(255, 244, 225)
linterna.Shadows = true
linterna.Parent = portaLuz

local luzSuave = Instance.new("PointLight")
luzSuave.Range = 16
luzSuave.Brightness = 0.35
luzSuave.Color = Color3.fromRGB(170, 190, 255)
luzSuave.Shadows = false
luzSuave.Parent = portaLuz

RunService.RenderStepped:Connect(function()
	local cam = workspace.CurrentCamera
	if cam and (linterna.Enabled or luzSuave.Enabled) then
		portaLuz.CFrame = cam.CFrame * CFrame.new(0.8, -0.6, -0.5)
	end
end)

actualizarNoche = function()
	linterna.Enabled = gfx.noche and gfx.linterna
	luzSuave.Enabled = gfx.noche and gfx.luzJugador
	aplicarGraficos()
end
end
actualizarNoche()

local aurora = {}
do
	local carpeta = Instance.new("Folder")
	carpeta.Name = "GFX_Aurora"
	local base = Instance.new("Part")
	base.Name = "GFX_AuroraBase"
	base.Anchored = true
	base.CanCollide = false
	base.CanQuery = false
	base.CanTouch = false
	base.Transparency = 1
	base.Size = Vector3.new(1, 1, 1)
	base.CFrame = CFrame.new()
	base.Parent = carpeta

	local tinte = Instance.new("ColorCorrectionEffect")
	tinte.Name = "GFX_AuroraLuz"
	tinte.Enabled = false
	tinte.Parent = Lighting

	local NSK = NumberSequenceKeypoint.new
	local function secuencia(rojo, rosa)
		local abajo = Color3.fromRGB(150, 70, 255):Lerp(Color3.fromRGB(255, 70, 160), rosa)
		local verde = Color3.fromRGB(90, 255, 150)
		local verde2 = Color3.fromRGB(40, 225, 125)
		local arriba = Color3.fromRGB(40, 180, 150):Lerp(Color3.fromRGB(235, 45, 90), rojo)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, abajo),
			ColorSequenceKeypoint.new(0.06, verde),
			ColorSequenceKeypoint.new(0.38, verde2),
			ColorSequenceKeypoint.new(0.7, verde2:Lerp(arriba, 0.65)),
			ColorSequenceKeypoint.new(1, arriba),
		})
	end
	-- borde de abajo marcado, se desvanece hacia arriba (como los rayos reales)
	local transCortina = NumberSequence.new({ NSK(0, 1), NSK(0.025, 0.55), NSK(0.09, 0.2), NSK(0.35, 0.45), NSK(0.7, 0.8), NSK(1, 1) })

	local function nuevoHaz(w0, w1, trans)
		local a0 = Instance.new("Attachment")
		local a1 = Instance.new("Attachment")
		a0.Parent, a1.Parent = base, base
		local b = Instance.new("Beam")
		b.Attachment0, b.Attachment1 = a0, a1
		b.Texture = ""
		b.FaceCamera = true
		b.LightEmission = 1
		b.LightInfluence = 0
		b.Segments = 2
		b.Width0, b.Width1 = w0, w1
		b.Transparency = trans
		b.Parent = base
		return { a0 = a0, a1 = a1, beam = b }
	end

	-- tres cortinas a distintas distancias: la cercana más alta y brillante
	local cortinas = {}
	for ci, c in ipairs({
		{ dist = 650, ancho = 2600, n = 46, alto = 140, largo = 360, fase = 0, brillo = 1 },
		{ dist = 950, ancho = 3400, n = 50, alto = 200, largo = 470, fase = 2.7, brillo = 0.8 },
		{ dist = 1300, ancho = 4300, n = 50, alto = 260, largo = 540, fase = 5.1, brillo = 0.6 },
	}) do
		local w = c.ancho / (c.n - 1) * 1.35
		local segs = {}
		for i = 1, c.n do segs[i] = nuevoHaz(w, w * 1.2, transCortina) end
		cortinas[ci] = { cfg = c, segs = segs }
	end

	-- corona: rayos que parecen juntarse arriba de tu cabeza en el pico de la tormenta
	local transCorona = NumberSequence.new({ NSK(0, 1), NSK(0.05, 0.35), NSK(0.5, 0.6), NSK(1, 1) })
	local corona = {}
	for i = 1, 18 do
		local h = nuevoHaz(34, 4, transCorona)
		h.angulo = (i / 18) * math.pi * 2
		corona[i] = h
	end

	-- bandas suaves: cintas anchas y difusas que cruzan el cielo y fluyen (verde -> turquesa -> azul)
	local NUBE_TEX = "rbxasset://textures/particles/smoke_main.dds"
	local transBanda = NumberSequence.new({ NSK(0, 1), NSK(0.12, 0.6), NSK(0.35, 0.28), NSK(0.5, 0.18), NSK(0.65, 0.28), NSK(0.88, 0.6), NSK(1, 1) })
	local bandas = {}
	for i, b in ipairs({
		{ az = -0.35, dist = 800, alto = 420, largo = 2600, ancho = 260, incl = 0.22, fase = 0, vel = 0.06, curva = 260 },
		{ az = -0.1, dist = 950, alto = 560, largo = 3000, ancho = 340, incl = 0.16, fase = 1.7, vel = 0.045, curva = -180 },
		{ az = 0.2, dist = 720, alto = 330, largo = 2200, ancho = 200, incl = 0.28, fase = 3.1, vel = 0.07, curva = 220 },
		{ az = 0.45, dist = 1100, alto = 700, largo = 3200, ancho = 420, incl = 0.12, fase = 4.4, vel = 0.035, curva = -240 },
		{ az = -0.6, dist = 1000, alto = 300, largo = 2400, ancho = 240, incl = 0.3, fase = 5.6, vel = 0.055, curva = 160 },
		{ az = 0.05, dist = 650, alto = 480, largo = 1800, ancho = 170, incl = 0.35, fase = 2.4, vel = 0.08, curva = -140 },
	}) do
		local h = nuevoHaz(b.ancho, b.ancho * 0.8, transBanda)
		h.beam.Texture = NUBE_TEX
		h.beam.TextureMode = Enum.TextureMode.Wrap
		h.beam.TextureLength = 380 + i * 40
		h.beam.TextureSpeed = b.vel
		h.beam.Segments = 40
		h.beam.CurveSize0 = b.curva
		h.beam.CurveSize1 = -b.curva * 0.6
		h.a0.Axis, h.a0.SecondaryAxis = Vector3.yAxis, Vector3.zAxis
		h.a1.Axis, h.a1.SecondaryAxis = Vector3.yAxis, Vector3.zAxis
		h.cfg = b
		bandas[i] = h
	end

	local meteoro = nuevoHaz(2.5, 0.2, NumberSequence.new({ NSK(0, 1), NSK(1, 0) }))
	meteoro.beam.Color = ColorSequence.new(Color3.fromRGB(200, 225, 255), Color3.new(1, 1, 1))
	meteoro.beam.Enabled = false

	-- escarcha brillante flotando (diamond dust)
	local cajaEscarcha = Instance.new("Part")
	cajaEscarcha.Name = "GFX_Escarcha"
	cajaEscarcha.Anchored = true
	cajaEscarcha.CanCollide = false
	cajaEscarcha.CanQuery = false
	cajaEscarcha.CanTouch = false
	cajaEscarcha.Transparency = 1
	cajaEscarcha.Size = Vector3.new(70, 22, 70)
	cajaEscarcha.Parent = carpeta
	local escarcha = Instance.new("ParticleEmitter")
	escarcha.Shape = Enum.ParticleEmitterShape.Box
	escarcha.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	escarcha.Rate = 45
	escarcha.Lifetime = NumberRange.new(5, 9)
	escarcha.Speed = NumberRange.new(0.3, 1.2)
	escarcha.SpreadAngle = Vector2.new(180, 180)
	escarcha.Acceleration = Vector3.new(0.3, -0.5, 0.2)
	escarcha.Size = NumberSequence.new({ NSK(0, 0.07), NSK(0.5, 0.14), NSK(1, 0.06) })
	escarcha.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.1, 0.2), NSK(0.25, 0.85), NSK(0.4, 0.1), NSK(0.55, 0.8), NSK(0.7, 0.15), NSK(0.85, 0.75), NSK(1, 1) })
	escarcha.Color = ColorSequence.new(Color3.fromRGB(190, 255, 235), Color3.new(1, 1, 1))
	escarcha.LightEmission = 1
	escarcha.LightInfluence = 0.2
	escarcha.Rotation = NumberRange.new(0, 360)
	escarcha.RotSpeed = NumberRange.new(-90, 90)
	escarcha.Enabled = false
	escarcha.Parent = cajaEscarcha

	local activa = false
	local t, acum, acumColor = 0, 0, 1
	local energia, objetivo = 0.45, 0.45
	local fase, tFase, proxima = "calma", 0, 20
	local met

	aurora.subtormenta = function()
		if activa then fase, tFase = "sube", 0 end
	end

	aurora.actualizar = function()
		activa = gfx.aurora and gfx.noche
		carpeta.Parent = activa and workspace or nil
		tinte.Enabled = activa
		escarcha.Enabled = activa and gfx.auroraEscarcha
		if not activa then meteoro.beam.Enabled = false; met = nil end
	end

	RunService.Heartbeat:Connect(function(dt)
		if not activa then return end
		local cam = workspace.CurrentCamera
		if not cam then return end
		local c = cam.CFrame.Position

		if met then
			local k = (os.clock() - met.t0) / met.dur
			if k >= 1 then
				meteoro.beam.Enabled = false
				met = nil
			else
				local cabeza = met.inicio + met.dir * (met.largo * k)
				local cola = cabeza - met.dir * (140 * math.min(1, k * 4))
				meteoro.a0.Position = cola
				meteoro.a1.Position = cabeza
				meteoro.beam.Brightness = 3 * math.sin(k * math.pi)
			end
		end

		acum += dt
		if acum < 1 / 30 then return end
		local paso = acum
		acum = 0

		-- ciclo de subtormenta: calma -> estallido -> pico -> pulsos
		tFase += paso
		if fase == "calma" then
			objetivo = 0.45 + 0.12 * math.sin(t * 0.05)
			if gfx.auroraSubtormentas and tFase > proxima then fase, tFase = "sube", 0 end
		elseif fase == "sube" then
			objetivo = 1.5
			if tFase > 4 then fase, tFase = "pico", 0 end
		elseif fase == "pico" then
			objetivo = 1.3 + 0.2 * math.sin(tFase * 2.3)
			if tFase > 12 then fase, tFase = "baja", 0 end
		else
			objetivo = 0.5 + 0.3 * math.max(0, math.sin(tFase * 0.8))
			if tFase > 26 then fase, tFase, proxima = "calma", 0, math.random(35, 80) end
		end
		energia += (objetivo - energia) * math.min(1, paso * (fase == "sube" and 1.3 or 0.35))
		t += paso * gfx.auroraVelocidad * (0.5 + energia * 0.9)

		local inten = gfx.auroraIntensidad
		local pulsando = fase == "baja"

		acumColor += paso
		if acumColor > 0.3 then
			acumColor = 0
			local rojo = math.clamp(gfx.auroraRojo * (0.25 + math.max(0, energia - 0.6) * 1.1), 0, 1)
			local rosa = math.clamp((energia - 1) / 0.45, 0, 1)
			local sec = secuencia(rojo, rosa)
			for _, cort in ipairs(cortinas) do
				for _, s in ipairs(cort.segs) do s.beam.Color = sec end
			end
			local secC = ColorSequence.new(Color3.fromRGB(255, 80, 170):Lerp(Color3.fromRGB(80, 255, 150), 0.6), Color3.fromRGB(200, 60, 160))
			for _, h in ipairs(corona) do h.beam.Color = secC end
		end

		for ci, cort in ipairs(cortinas) do
			local cfg = cort.cfg
			for i, s in ipairs(cort.segs) do
				local u = (i - 1) / (cfg.n - 1) - 0.5
				local x = u * cfg.ancho
				local z = -cfg.dist - (u * u) * cfg.dist * 0.8
					+ math.sin(x * 0.0016 + t * 0.07 + cfg.fase) * 170
					+ math.noise(x * 0.0009, t * 0.05, cfg.fase) * 260
				local yb = cfg.alto + math.noise(x * 0.002, t * 0.08, 10 + ci) * 40
				local largo = cfg.largo * (0.6 + 0.8 * (math.noise(x * 0.006, t * 0.3, 20 + ci) + 0.5)) * (0.75 + energia * 0.3)
				local p = c + Vector3.new(x, yb, z)
				s.a0.Position = p
				s.a1.Position = p + Vector3.new(0, largo, 0)
				local onda = math.noise(x * 0.004 - t * 0.6, ci * 3.1, t * 0.15) + 0.5
				local pulso = pulsando and (0.65 + 0.35 * math.sin(t * 1.7 + x * 0.008)) or 1
				local borde = math.clamp(1 - math.abs(u) * 2, 0, 1) ^ 0.6
				s.beam.Brightness = inten * cfg.brillo * borde * (0.35 + onda * 1.1) * energia * pulso * 2 * gfx.auroraRayos
			end
		end

		-- bandas suaves que se mueven despacio y cambian de verde a azul
		local verde, turquesa, azul = Color3.fromRGB(80, 255, 160), Color3.fromRGB(60, 230, 210), Color3.fromRGB(70, 150, 255)
		for _, h in ipairs(bandas) do
			local b = h.cfg
			h.beam.Enabled = gfx.auroraBandas
			if gfx.auroraBandas then
				local az = b.az + math.sin(t * 0.02 + b.fase) * 0.12
				local radial = Vector3.new(math.sin(az), 0, -math.cos(az))
				local lado = Vector3.new(math.cos(az), 0, math.sin(az))
				local centro = c + radial * (b.dist + math.sin(t * 0.03 + b.fase) * 60) + Vector3.new(0, b.alto + math.sin(t * 0.05 + b.fase) * 40, 0)
				local mitad = lado * (b.largo / 2) + Vector3.new(0, b.largo * b.incl * 0.5, 0)
				h.a0.Position = centro - mitad
				h.a1.Position = centro + mitad
				local mezcla = (math.sin(t * 0.12 + b.fase) + 1) / 2
				local medio = verde:Lerp(azul, mezcla * 0.85)
				h.beam.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, turquesa:Lerp(azul, mezcla)),
					ColorSequenceKeypoint.new(0.5, medio),
					ColorSequenceKeypoint.new(1, turquesa:Lerp(verde, 1 - mezcla)),
				})
				local respira = 0.75 + 0.25 * math.sin(t * 0.4 + b.fase * 1.3)
				h.beam.Brightness = inten * respira * math.clamp(energia, 0.5, 1.5) * 1.5
			end
		end

		local fuerzaCorona = math.clamp((energia - 1.05) * 3, 0, 1) * inten
		local arriba = c + Vector3.new(0, 1150, -150)
		for _, h in ipairs(corona) do
			h.beam.Enabled = fuerzaCorona > 0.01
			if h.beam.Enabled then
				local a = h.angulo + t * 0.03
				h.a0.Position = c + Vector3.new(math.cos(a) * 650, 420 + math.noise(a, t * 0.3) * 60, math.sin(a) * 650 - 150)
				h.a1.Position = arriba
				h.beam.Brightness = fuerzaCorona * (1 + 0.8 * math.noise(a * 3, t * 1.5)) * 1.6
			end
		end

		tinte.TintColor = Color3.new(1, 1, 1):Lerp(Color3.fromRGB(200, 255, 225), math.clamp(energia * 0.3 * inten, 0, 0.6))
		tinte.Brightness = 0.025 * energia * inten
		cajaEscarcha.CFrame = CFrame.new(c + Vector3.new(0, 6, 0))

		if gfx.auroraFugaces and not met and math.random() < paso / 14 then
			local a = math.random() * math.pi * 2
			local dir = Vector3.new(math.cos(a + 2) , -0.35 - math.random() * 0.3, math.sin(a + 2)).Unit
			met = {
				t0 = os.clock(), dur = 0.5 + math.random() * 0.5, dir = dir, largo = 380 + math.random() * 300,
				inicio = c + Vector3.new(math.cos(a) * 900, 650 + math.random() * 300, math.sin(a) * 900),
			}
			meteoro.beam.Enabled = true
		end
	end)
end

local extras = {}
do
	local HUMO = "rbxasset://textures/particles/smoke_main.dds"
	local NSK = NumberSequenceKeypoint.new
	local carpeta = Instance.new("Folder")
	carpeta.Name = "GFX_Extras"
	carpeta.Parent = workspace

	local function cajaInvisible(nombre, size)
		local p = Instance.new("Part")
		p.Name = nombre
		p.Anchored = true
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.Transparency = 1
		p.Size = size
		p.Parent = carpeta
		return p
	end

	local rayoSuelo = RaycastParams.new()
	rayoSuelo.FilterType = Enum.RaycastFilterType.Exclude
	local function sueloBajo(pos)
		local excluir = { carpeta }
		if player.Character then table.insert(excluir, player.Character) end
		rayoSuelo.FilterDescendantsInstances = excluir
		local hit = workspace:Raycast(pos + Vector3.new(0, 20, 0), Vector3.new(0, -400, 0), rayoSuelo)
		return hit and hit.Position.Y or (pos.Y - 5)
	end

	-- luces suaves del sol: haces con la textura del sol que se SUMAN a la imagen
	-- (sin círculos planos encimados, el borde se desvanece solo)
	local SOL_TEX = "rbxasset://sky/sun.jpg"
	local baseLuz = cajaInvisible("GFX_LuzSol", Vector3.new(0.2, 0.2, 0.2))
	baseLuz.CFrame = CFrame.new()
	local function haz(color)
		local a0 = Instance.new("Attachment")
		local a1 = Instance.new("Attachment")
		a0.Parent, a1.Parent = baseLuz, baseLuz
		local b = Instance.new("Beam")
		b.Attachment0, b.Attachment1 = a0, a1
		b.Texture = SOL_TEX
		b.TextureMode = Enum.TextureMode.Stretch
		b.TextureLength = 1
		b.FaceCamera = true
		b.LightEmission = 1
		b.LightInfluence = 0
		b.Segments = 1
		b.Color = ColorSequence.new(color)
		-- se desvanece hacia los bordes para que no se note el corte del círculo
		b.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2, 0.75), NumberSequenceKeypoint.new(0.38, 0.25),
			NumberSequenceKeypoint.new(0.5, 0.1), NumberSequenceKeypoint.new(0.62, 0.25), NumberSequenceKeypoint.new(0.8, 0.75),
			NumberSequenceKeypoint.new(1, 1),
		})
		b.Enabled = false
		b.Parent = baseLuz
		return { a0 = a0, a1 = a1, b = b }
	end
	local function ponerHaz(h, centro, eje, largo, ancho, brillo)
		h.a0.Position = centro - eje * (largo / 2)
		h.a1.Position = centro + eje * (largo / 2)
		h.b.Width0, h.b.Width1 = ancho, ancho
		h.b.Brightness = brillo
		h.b.Enabled = brillo > 0.01
	end
	local function apagarHaz(h) h.b.Enabled = false end

	-- resplandor cálido en pantalla cuando miras directo al sol
	local flareGui = Instance.new("ScreenGui")
	flareGui.Name = "GFX_Destello"
	flareGui.IgnoreGuiInset = true
	flareGui.ResetOnSpawn = false
	flareGui.DisplayOrder = -998
	local velo = Instance.new("Frame")
	velo.Size = UDim2.fromScale(1, 1)
	velo.BorderSizePixel = 0
	velo.BackgroundColor3 = Color3.fromRGB(255, 236, 205)
	velo.BackgroundTransparency = 1
	velo.Parent = flareGui
	flareGui.Parent = player:WaitForChild("PlayerGui")
	local visible = 0
	local rayoSol = RaycastParams.new()
	rayoSol.FilterType = Enum.RaycastFilterType.Exclude

	-- luciérnagas
	local cajaLuz = cajaInvisible("GFX_Luciernagas", Vector3.new(90, 6, 90))
	local luciernagas = Instance.new("ParticleEmitter")
	luciernagas.Shape = Enum.ParticleEmitterShape.Box
	luciernagas.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	luciernagas.Lifetime = NumberRange.new(6, 10)
	luciernagas.Speed = NumberRange.new(0.4, 1.4)
	luciernagas.SpreadAngle = Vector2.new(180, 180)
	luciernagas.Drag = 0.4
	luciernagas.Size = NumberSequence.new({ NSK(0, 0.1), NSK(0.5, 0.18), NSK(1, 0.1) })
	luciernagas.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.08, 1), NSK(0.15, 0.05), NSK(0.25, 0.9), NSK(0.42, 1),
		NSK(0.5, 0.1), NSK(0.6, 0.95), NSK(0.78, 1), NSK(0.85, 0.05), NSK(0.93, 0.95), NSK(1, 1) })
	luciernagas.Color = ColorSequence.new(Color3.fromRGB(215, 255, 90), Color3.fromRGB(255, 240, 120))
	luciernagas.LightEmission = 1
	luciernagas.LightInfluence = 0
	luciernagas.Enabled = false
	luciernagas.Parent = cajaLuz

	-- neblina baja (pegada al suelo)
	local cajaNiebla = cajaInvisible("GFX_NieblaBaja", Vector3.new(150, 2, 150))
	local nieblaBaja = Instance.new("ParticleEmitter")
	nieblaBaja.Texture = HUMO
	nieblaBaja.Shape = Enum.ParticleEmitterShape.Box
	nieblaBaja.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
	nieblaBaja.Lifetime = NumberRange.new(12, 18)
	nieblaBaja.Speed = NumberRange.new(0.2, 0.8)
	nieblaBaja.SpreadAngle = Vector2.new(180, 5)
	nieblaBaja.Rotation = NumberRange.new(0, 360)
	nieblaBaja.RotSpeed = NumberRange.new(-4, 4)
	nieblaBaja.Size = NumberSequence.new({ NSK(0, 10), NSK(1, 22) })
	nieblaBaja.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.3, 0.9), NSK(0.7, 0.9), NSK(1, 1) })
	nieblaBaja.LightEmission = 0.05
	nieblaBaja.LightInfluence = 1
	nieblaBaja.Enabled = false
	nieblaBaja.Parent = cajaNiebla

	-- sol del cielo: varias capas de luz suave (centro, corona, resplandor y brillo del horizonte)
	local DIST_SOL = 600
	local solResplandor = haz(Color3.new(1, 1, 1))
	local solCorona = haz(Color3.new(1, 1, 1))
	local solCentro = haz(Color3.new(1, 1, 1))
	local solTam = nil
	local function cieloSol()
		local cielo = Lighting:FindFirstChildOfClass("Sky")
		if cielo and cielo:GetAttribute("GFX_SolTam") == nil then cielo:SetAttribute("GFX_SolTam", cielo.SunAngularSize) end
		return cielo
	end

	-- remolinos de polvo
	local remolino = cajaInvisible("GFX_Remolino", Vector3.new(4, 1, 4))
	local giro = Instance.new("ParticleEmitter")
	giro.Texture = HUMO
	giro.Shape = Enum.ParticleEmitterShape.Cylinder
	giro.ShapeStyle = Enum.ParticleEmitterShapeStyle.Surface
	giro.EmissionDirection = Enum.NormalId.Top
	giro.Lifetime = NumberRange.new(2.5, 4)
	giro.Speed = NumberRange.new(6, 11)
	giro.SpreadAngle = Vector2.new(10, 10)
	giro.Rotation = NumberRange.new(0, 360)
	giro.RotSpeed = NumberRange.new(-320, 320)
	giro.Size = NumberSequence.new({ NSK(0, 2), NSK(0.6, 5), NSK(1, 9) })
	giro.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.15, 0.78), NSK(0.6, 0.86), NSK(1, 1) })
	giro.LightInfluence = 1
	giro.Enabled = false
	giro.Parent = remolino
	local rem
	local proximoRem = 15

	extras.actualizar = function()
		local cielo = cieloSol()
		if cielo then
			local quiere = gfx.solRealista and not gfx.noche and not gfx.lluvia and not SKYBOXES.sinSol
			local tam = cielo:GetAttribute("GFX_SolTam")
			if quiere then tam = math.max(tam, 11) end
			if solTam ~= tam then
				solTam = tam
				cielo.SunAngularSize = tam
			end
		end
		luciernagas.Enabled = gfx.noche and gfx.luciernagas > 0
		luciernagas.Rate = gfx.luciernagas / 8
		nieblaBaja.Enabled = gfx.nieblaBaja > 0 and not gfx.lluvia
		nieblaBaja.Rate = gfx.nieblaBaja
		nieblaBaja.Color = ColorSequence.new(gfx.nieblaBajaColor)
		if not gfx.remolinos or gfx.lluvia or gfx.noche then
			giro.Enabled = false
			rem = nil
		end
		giro.Color = ColorSequence.new(gfx.polvoColor:Lerp(Color3.fromRGB(150, 125, 95), 0.45))
	end

	local reloj, deriva = 0, Vector3.zero
	RunService:BindToRenderStep("GFX_Extras", Enum.RenderPriority.Camera.Value + 2, function(dt)
		local cam = workspace.CurrentCamera
		if not cam then return end
		local c = cam.CFrame.Position

		-- destello del sol
		local dirSol = Lighting:GetSunDirection()
		local quiere = gfx.destelloSol and not gfx.noche and not gfx.lluvia and not SKYBOXES.sinSol and dirSol.Y > -0.02
		local sx, sy, centralidad = 0, 0, 0
		if quiere then
			local p, enPantalla = cam:WorldToViewportPoint(c + dirSol * 1000)
			local vp = cam.ViewportSize
			if enPantalla and p.Z > 0 then
				local excluir = { carpeta }
				if player.Character then table.insert(excluir, player.Character) end
				rayoSol.FilterDescendantsInstances = excluir
				local tapado = false
				local desde = c
				for _ = 1, 4 do
					local hit = workspace:Raycast(desde, dirSol * 3000, rayoSol)
					if not hit then break end
					if hit.Instance.Transparency < 0.9 then tapado = true break end
					table.insert(excluir, hit.Instance)
					rayoSol.FilterDescendantsInstances = excluir
				end
				if not tapado then
					sx, sy = p.X, p.Y
					local dx, dy = (sx - vp.X / 2) / vp.X, (sy - vp.Y / 2) / vp.Y
					centralidad = math.clamp(1 - math.sqrt(dx * dx + dy * dy) * 1.6, 0, 1)
				else
					quiere = false
				end
			else
				quiere = false
			end
		end
		visible += ((quiere and 1 or 0) - visible) * math.min(dt * 5, 1)
		local f = visible * gfx.destelloFuerza
		flareGui.Enabled = f > 0.01
		if flareGui.Enabled then
			velo.BackgroundTransparency = 1 - 0.1 * f * centralidad * centralidad
		end

		-- luciérnagas y neblina siguen a la cámara, pegadas al suelo
		reloj += dt
		if reloj > 0.25 then
			reloj = 0
			local y = sueloBajo(c)
			if luciernagas.Enabled then
				cajaLuz.CFrame = CFrame.new(c.X, y + 2.5, c.Z)
				deriva = Vector3.new(math.random() - 0.5, (math.random() - 0.5) * 0.4, math.random() - 0.5) * 0.8
				luciernagas.Acceleration = deriva
			end
			if nieblaBaja.Enabled then
				cajaNiebla.CFrame = CFrame.new(c.X, y + 1.2, c.Z)
				nieblaBaja.Acceleration = Vector3.new(gfx.brisa * 0.6, 0, gfx.brisa * 0.25)
			end
		end

		-- sol realista: capas de luz justo donde está el sol del cielo
		local dirS = Lighting:GetSunDirection()
		if gfx.solRealista and not gfx.noche and not gfx.lluvia and not SKYBOXES.sinSol and dirS.Y > -0.06 then
			local centroSol = c + dirS * DIST_SOL
			local elev = math.deg(math.asin(math.clamp(dirS.Y, -1, 1)))
			local alto = math.clamp(elev / 18, 0, 1)
			solCentro.b.Color = ColorSequence.new(Color3.fromRGB(255, 214, 160):Lerp(Color3.fromRGB(255, 252, 244), alto))
			solCorona.b.Color = ColorSequence.new(Color3.fromRGB(255, 150, 80):Lerp(Color3.fromRGB(255, 232, 190), alto))
			solResplandor.b.Color = ColorSequence.new(Color3.fromRGB(255, 115, 55):Lerp(Color3.fromRGB(255, 214, 165), alto))
			local L = DIST_SOL * gfx.solTamano
			local b = gfx.solBrillo
			-- el eje va perpendicular a la vista para que siempre se vea redondo
			local eje = cam.CFrame.UpVector
			-- más transparentes; el resplandor grande se apoya en el brillo natural de la atmósfera
			ponerHaz(solCentro, centroSol, eje, L * 0.08, L * 0.07, 1.4 * b)
			ponerHaz(solCorona, centroSol, eje, L * 0.3, L * 0.24, 0.4 * b)
			ponerHaz(solResplandor, centroSol, eje, L * 0.85, L * 0.6, 0.12 * b)
		else
			apagarHaz(solCentro)
			apagarHaz(solCorona)
			apagarHaz(solResplandor)
		end

		-- remolinos de polvo cada tanto
		if gfx.remolinos and not gfx.lluvia and not gfx.noche then
			if not rem then
				proximoRem -= dt
				if proximoRem <= 0 then
					local ang = math.random() * math.pi * 2
					local d = 45 + math.random() * 90
					local inicio = c + Vector3.new(math.cos(ang) * d, 0, math.sin(ang) * d)
					rem = { pos = inicio, vel = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5).Unit * (3 + math.random() * 4), t = 0, dur = 9 + math.random() * 7 }
					giro.Enabled = true
				end
			else
				rem.t += dt
				rem.pos += (rem.vel + Vector3.new(math.sin(rem.t * 2.1), 0, math.cos(rem.t * 1.7)) * 2) * dt
				local y = sueloBajo(rem.pos)
				remolino.CFrame = CFrame.new(rem.pos.X, y + 0.5, rem.pos.Z)
				local k = rem.t / rem.dur
				giro.Rate = 70 * math.sin(math.clamp(k, 0, 1) * math.pi)
				if k >= 1 then
					giro.Enabled = false
					rem = nil
					proximoRem = 20 + math.random() * 30
				end
			end
		end
	end)
end

local function aplicarTodo()
	-- si una parte falla, las demás se aplican igual
	for _, f in ipairs({
		aplicarGraficos, actualizarParticulas, actualizarVineta, actualizarAgua, actualizarSuperficies,
		actualizarReflejo, actualizarNoche,
		function() if gfx.lluvia then actualizarCeldas() else apagarCeldas() end end,
		aurora.actualizar, extras.actualizar,
	}) do
		local ok, err = pcall(f)
		if not ok then warn("[4Phant0nmnn] " .. tostring(err)) end
	end
end

local function alternarShader()
	local apagados = sinShader.apagados or {}
	sinShader.apagados = apagados
	sinShader.activo = not sinShader.activo
	if sinShader.activo then
		for _, k in ipairs({ "polvo", "vineta", "pisosBrillantes", "superficiesBrillantes", "pisoVidrio", "pisoMojado", "barniz",
			"aguaReflejo", "lluvia", "tormenta", "noche", "aurora", "linterna", "luzJugador", "pastoViento", "lejosBorroso",
			"destelloSol", "remolinos", "luciernagas", "nieblaBaja", "solRealista" }) do
			apagados[k] = gfx[k]
			gfx[k] = type(gfx[k]) == "number" and 0 or false
		end
		apagados.reflejo = ref.activado
		ref.activado = false
	else
		for k, v in pairs(apagados) do
			if k == "reflejo" then ref.activado = v else gfx[k] = v end
		end
		table.clear(apagados)
	end
	aplicarTodo()
	return not sinShader.activo
end

local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local ui = {
	titulo = "4Phant0nmnn",
	subtitulo = "shader",
	tecla = Enum.KeyCode.K,
	abrirAlEntrar = true,
	entrada = true,
	acento = Color3.fromRGB(235, 235, 240),
	transparencia = 0,
	escala = 1,
	esquinas = 1,
	fuente = 1,
	animaciones = true,
	velocidadAnim = 1,
	scrollSuave = true,
	pasoRueda = 1,
	puntero = true,
	desenfocarFondo = true,
	mostrarFps = false,
	idioma = 1,
	teclaShader = Enum.KeyCode.F,
}

local TRAD = {
	["High graphics quality is recommended"] = { "Se recomienda activar buena calidad", "Recomenda-se ativar boa qualidade gráfica", "Рекомендуется включить высокое качество графики" },
	["Skys"] = { "Cielos", "Céus", "Небо" },
	["Skyboxes"] = { "Skyboxes", "Skyboxes", "Скайбоксы" },
	["Skybox"] = { "Skybox", "Skybox", "Скайбокс" },
	["Map Sky"] = { "Cielo del mapa", "Céu do mapa", "Небо карты" },
	["Remove Preset"] = { "Quitar preset", "Remover preset", "Убрать пресет" },
	["Mirror Sharpness"] = { "Nitidez del espejo", "Nitidez do espelho", "Чёткость зеркала" },
	["Soft Bands"] = { "Bandas suaves", "Faixas suaves", "Мягкие полосы" },
	["Curtain Rays"] = { "Rayos de cortina", "Raios de cortina", "Лучи занавеса" },
	["World Reflection"] = { "Reflejo del mundo", "Reflexo do mundo", "Отражение мира" },
	["Radius"] = { "Radio", "Raio", "Радиус" },
	["Mirrors the nearby world on shiny floors so the reflection moves as you walk."] = { "Refleja lo que hay cerca en los pisos brillantes para que el reflejo se mueva al caminar.", "Reflete o que está perto nos pisos brilhantes para o reflexo se mover ao andar.", "Отражает ближайший мир на блестящих полах, чтобы отражение двигалось при ходьбе." },
	["Shadow Fill"] = { "Relleno de sombras", "Preenchimento de sombras", "Заполнение теней" },
	["Sun Follows Sky"] = { "Sol sigue al cielo", "Sol segue o céu", "Солнце по небу" },
	["Sky Lighting"] = { "Luz del cielo", "Luz do céu", "Свет неба" },
	["Lighting Strength"] = { "Fuerza de la luz", "Força da luz", "Сила света" },
	["More Skies"] = { "Más cielos", "Mais céus", "Ещё небеса" },
	["Sky Options"] = { "Opciones del cielo", "Opções do céu", "Настройки неба" },
	["Sky Rotation"] = { "Rotación del cielo", "Rotação do céu", "Поворот неба" },
	["Cloud Drift"] = { "Movimiento de nubes", "Movimento das nuvens", "Движение облаков" },
	["Your sky stays when you change presets."] = { "Tu cielo se queda aunque cambies de preset.", "Seu céu continua mesmo trocando de preset.", "Небо остаётся при смене пресета." },
	["Cloud Drift slowly turns the sky so the clouds move."] = { "Movimiento de nubes gira el cielo despacio para que las nubes avancen.", "Movimento das nuvens gira o céu devagar para as nuvens andarem.", "Движение облаков медленно вращает небо, и облака плывут." },
	["Realistic Sun"] = { "Sol realista", "Sol realista", "Реалистичное солнце" },
	["Sun Glow"] = { "Resplandor del sol", "Brilho do sol", "Сияние солнца" },
	["Sun Size"] = { "Tamaño del sol", "Tamanho do sol", "Размер солнца" },
	["Choose a preset"] = { "Elige un preset", "Escolha um preset", "Выберите пресет" },
	["Pick how the game will look. You can change it later in the panel."] = { "Elige cómo se verá el juego. Puedes cambiarlo luego en el panel.", "Escolha como o jogo vai ficar. Você pode mudar depois no painel.", "Выберите, как будет выглядеть игра. Потом можно изменить в панели." },
	["Click a card or press 1-5"] = { "Haz clic en una tarjeta o pulsa 1-5", "Clique em um cartão ou aperte 1-5", "Нажмите на карточку или клавиши 1-5" },
	["Warm afternoon sun, dust in the air and sharp shadows."] = { "Sol cálido de la tarde, polvo en el aire y sombras marcadas.", "Sol quente da tarde, poeira no ar e sombras marcadas.", "Тёплое дневное солнце, пыль в воздухе и чёткие тени." },
	["Golden hour, long shadows, glowing haze and sun flare."] = { "Hora dorada, sombras largas, bruma brillante y destello del sol.", "Hora dourada, sombras longas, névoa brilhante e reflexo do sol.", "Золотой час, длинные тени, светящаяся дымка и блик солнца." },
	["Moonlit night with soft mist and fireflies."] = { "Noche de luna con neblina suave y luciérnagas.", "Noite de lua com névoa suave e vaga-lumes.", "Лунная ночь с лёгким туманом и светлячками." },
	["Northern lights dancing over a starry sky."] = { "Auroras boreales bailando sobre un cielo estrellado.", "Auroras boreais dançando num céu estrelado.", "Северное сияние танцует над звёздным небом." },
	["Heavy rain, strong wind and lightning strikes."] = { "Lluvia fuerte, viento y rayos.", "Chuva forte, vento e raios.", "Ливень, сильный ветер и молнии." },
	["Lens Flare"] = { "Destello de lente", "Reflexo de lente", "Блик объектива" },
	["Sun Flare"] = { "Destello del sol", "Reflexo do sol", "Блик солнца" },
	["Nature"] = { "Naturaleza", "Natureza", "Природа" },
	["Breeze"] = { "Brisa", "Brisa", "Ветерок" },
	["Dust Devils"] = { "Remolinos de polvo", "Redemoinhos de poeira", "Пыльные вихри" },
	["Fireflies"] = { "Luciérnagas", "Vaga-lumes", "Светлячки" },
	["Low Mist"] = { "Neblina baja", "Névoa baixa", "Низкий туман" },
	["Mist Color"] = { "Color de neblina", "Cor da névoa", "Цвет тумана" },
	["Aurora"] = { "Aurora", "Aurora", "Северное сияние" },
	["Northern Lights"] = { "Aurora boreal", "Aurora boreal", "Полярное сияние" },
	["Red Tops"] = { "Puntas rojas", "Pontas vermelhas", "Красные верхушки" },
	["Substorms"] = { "Subtormentas", "Subtempestades", "Суббури" },
	["Shooting Stars"] = { "Estrellas fugaces", "Estrelas cadentes", "Падающие звёзды" },
	["Diamond Dust"] = { "Escarcha brillante", "Pó de diamante", "Алмазная пыль" },
	["Trigger Substorm"] = { "Lanzar subtormenta", "Iniciar subtempestade", "Запустить суббурю" },
	["Needs Night Mode on."] = { "Necesita el modo noche activado.", "Precisa do modo noite ligado.", "Нужен включённый ночной режим." },
	["Shader Key"] = { "Tecla del shader", "Tecla do shader", "Клавиша шейдера" },
	["Shader ON"] = { "Shader ACTIVADO", "Shader LIGADO", "Шейдер ВКЛ" },
	["Shader OFF"] = { "Shader APAGADO", "Shader DESLIGADO", "Шейдер ВЫКЛ" },
	["Panel"] = { "Panel", "Painel", "Панель" },
	["Home"] = { "Inicio", "Início", "Главная" },
	["Search settings..."] = { "Buscar ajustes...", "Pesquisar ajustes...", "Поиск настроек..." },
	["General"] = { "General", "Geral", "Общее" },
	["Lighting"] = { "Iluminación", "Iluminação", "Освещение" },
	["Color"] = { "Color", "Cor", "Цвет" },
	["Atmosphere"] = { "Atmósfera", "Atmosfera", "Атмосфера" },
	["Effects"] = { "Efectos", "Efeitos", "Эффекты" },
	["Surfaces"] = { "Superficies", "Superfícies", "Поверхности" },
	["Floors & Glass"] = { "Pisos y vidrio", "Pisos e vidro", "Полы и стекло" },
	["Reflection"] = { "Reflejo", "Reflexo", "Отражение" },
	["Ambient"] = { "Ambiente", "Ambiente", "Окружение" },
	["Particles"] = { "Partículas", "Partículas", "Частицы" },
	["Weather"] = { "Clima", "Clima", "Погода" },
	["Settings"] = { "Ajustes", "Configurações", "Настройки" },
	["Cinematic"] = { "Cinemático", "Cinematográfico", "Кинематографичный" },
	["Sunset"] = { "Atardecer", "Pôr do sol", "Закат" },
	["Night"] = { "Noche", "Noite", "Ночь" },
	["Thunderstorm"] = { "Tormenta eléctrica", "Tempestade elétrica", "Гроза" },
	["Presets"] = { "Presets", "Predefinições", "Пресеты" },
	["Reset to Default"] = { "Volver a lo original", "Restaurar original", "Вернуть по умолчанию" },
	["Info"] = { "Info", "Info", "Инфо" },
	["Press K to hide or show this panel."] = { "Pulsa K para esconder o mostrar este panel.", "Pressione K para esconder ou mostrar este painel.", "Нажмите K, чтобы скрыть или показать панель." },
	["Floors and glass shine a lot more with Lighting > Technology set to Future."] = { "Los pisos y el vidrio brillan mucho más con Lighting > Technology en Future.", "Os pisos e o vidro brilham muito mais com Lighting > Technology em Future.", "Полы и стекло блестят намного сильнее с Lighting > Technology = Future." },
	["Sun"] = { "Sol", "Sol", "Солнце" },
	["Time of Day"] = { "Hora del día", "Hora do dia", "Время суток" },
	["Sun Direction"] = { "Dirección del sol", "Direção do sol", "Направление солнца" },
	["Brightness"] = { "Brillo", "Brilho", "Яркость" },
	["Exposure"] = { "Exposición", "Exposição", "Экспозиция" },
	["Shadows"] = { "Sombras", "Sombras", "Тени" },
	["Softness"] = { "Suavidad", "Suavidade", "Мягкость" },
	["Outdoor"] = { "Exterior", "Externo", "Снаружи" },
	["Correction"] = { "Corrección", "Correção", "Коррекция" },
	["Saturation"] = { "Saturación", "Saturação", "Насыщенность" },
	["Contrast"] = { "Contraste", "Contraste", "Контраст" },
	["Tint"] = { "Tinte", "Matiz", "Оттенок" },
	["Tone"] = { "Tono", "Tom", "Тон" },
	["Mist"] = { "Neblina", "Névoa", "Дымка" },
	["Haze"] = { "Haze", "Haze", "Мгла" },
	["Glare"] = { "Glare", "Brilho solar", "Блики" },
	["Density"] = { "Densidad", "Densidade", "Плотность" },
	["Height"] = { "Altura", "Altura", "Высота" },
	["Near Fog"] = { "Niebla cercana", "Névoa próxima", "Ближний туман" },
	["Sky"] = { "Cielo", "Céu", "Небо" },
	["Remove Fog"] = { "Quitar Fog", "Remover Fog", "Убрать Fog" },
	["Clear Sky"] = { "Cielo despejado", "Céu limpo", "Ясное небо" },
	["Clouds"] = { "Nubes", "Nuvens", "Облака" },
	["Bloom"] = { "Bloom", "Bloom", "Свечение" },
	["Intensity"] = { "Intensidad", "Intensidade", "Интенсивность" },
	["Size"] = { "Tamaño", "Tamanho", "Размер" },
	["Threshold"] = { "Umbral", "Limiar", "Порог" },
	["Sun Rays"] = { "Sun Rays", "Raios de sol", "Солнечные лучи" },
	["Spread"] = { "Alcance", "Alcance", "Охват" },
	["Depth"] = { "Profundidad", "Profundidade", "Глубина" },
	["Far Blur"] = { "Lejos borroso", "Desfoque distante", "Размытие вдали" },
	["Focus Distance"] = { "Distancia nítida", "Distância de foco", "Дистанция фокуса" },
	["Focus Radius"] = { "Radio nítido", "Raio de foco", "Радиус фокуса" },
	["Near Blur"] = { "Cerca borroso", "Desfoque próximo", "Размытие вблизи" },
	["Vignette"] = { "Viñeta", "Vinheta", "Виньетка" },
	["Enabled"] = { "Activada", "Ativada", "Включена" },
	["Strength"] = { "Fuerza", "Força", "Сила" },
	["Floors"] = { "Pisos", "Pisos", "Полы" },
	["Shiny Floors"] = { "Pisos brillantes", "Pisos brilhantes", "Блестящие полы" },
	["Wet"] = { "Mojado", "Molhado", "Мокрый" },
	["Wet Shine"] = { "Brillo mojado", "Brilho molhado", "Мокрый блеск" },
	["Darken"] = { "Oscurecer", "Escurecer", "Затемнение" },
	["Glass"] = { "Vidrio", "Vidro", "Стекло" },
	["Glass Floor"] = { "Piso de vidrio", "Piso de vidro", "Стеклянный пол" },
	["Transparency"] = { "Transparencia", "Transparência", "Прозрачность" },
	["Walls & Textures"] = { "Paredes y texturas", "Paredes e texturas", "Стены и текстуры" },
	["Shiny Walls"] = { "Paredes brillantes", "Paredes brilhantes", "Блестящие стены" },
	["Wall Shine"] = { "Brillo paredes", "Brilho das paredes", "Блеск стен" },
	["Gloss Coat"] = { "Barniz", "Verniz", "Лак" },
	["Gloss Strength"] = { "Fuerza barniz", "Força do verniz", "Сила лака" },
	["Wet Gloss"] = { "Barniz mojado", "Verniz molhado", "Мокрый лак" },
	["Water"] = { "Agua", "Água", "Вода" },
	["Reflective Water"] = { "Agua reflejante", "Água reflexiva", "Отражающая вода" },
	["Player Reflection"] = { "Reflejo del jugador", "Reflexo do jogador", "Отражение игрока" },
	["On"] = { "Activado", "Ativado", "Вкл." },
	["Opacity"] = { "Opacidad", "Opacidade", "Непрозрачность" },
	["Smear"] = { "Arrastre", "Arrasto", "Размазывание" },
	["Blur"] = { "Desenfoque", "Desfoque", "Размытие" },
	["Shape"] = { "Forma", "Forma", "Форма" },
	["Falloff"] = { "Caída", "Queda", "Спад" },
	["Dust"] = { "Polvo", "Poeira", "Пыль" },
	["Fine Dust"] = { "Polvo fino", "Poeira fina", "Мелкая пыль" },
	["Sparkles"] = { "Destellos", "Brilhos", "Искры" },
	["Sand"] = { "Arena", "Areia", "Песок" },
	["Rain"] = { "Lluvia", "Chuva", "Дождь" },
	["Make It Rain"] = { "Llover", "Chover", "Включить дождь" },
	["Splashes"] = { "Salpicaduras", "Respingos", "Брызги" },
	["Wind"] = { "Viento", "Vento", "Ветер" },
	["Speed"] = { "Velocidad", "Velocidade", "Скорость" },
	["Drop Length"] = { "Largo de gota", "Comprimento da gota", "Длина капли" },
	["Overcast"] = { "Nublado", "Nublado", "Пасмурно" },
	["Lightning"] = { "Relámpagos", "Relâmpagos", "Молнии" },
	["Near Drops"] = { "Gotas cercanas", "Gotas próximas", "Ближние капли" },
	["Lens Drops"] = { "Gotas en la cámara", "Gotas na câmera", "Капли на камере" },
	["Ground Mist"] = { "Neblina del suelo", "Névoa do chão", "Туман у земли" },
	["Storm"] = { "Tormenta", "Tempestade", "Шторм" },
	["Bolt Every (min)"] = { "Rayos cada (mín)", "Raio a cada (mín)", "Молния каждые (мин)" },
	["Bolt Every (max)"] = { "Rayos cada (máx)", "Raio a cada (máx)", "Молния каждые (макс)" },
	["Ground Strikes"] = { "Rayos a tierra", "Raios no chão", "Удары в землю" },
	["Gusts"] = { "Ráfagas", "Rajadas", "Порывы" },
	["Rain Curtains"] = { "Cortinas de agua", "Cortinas de chuva", "Стены дождя" },
	["Leaves & Debris"] = { "Hojas y basura", "Folhas e detritos", "Листья и мусор" },
	["Windy Grass"] = { "Pasto con viento", "Grama com vento", "Трава на ветру" },
	["Grass Strength"] = { "Fuerza del pasto", "Força da grama", "Сила травы" },
	["Thunder Shake"] = { "Temblor con truenos", "Tremor com trovões", "Тряска от грома" },
	["Strike Lightning Now"] = { "Lanzar un rayo ahora", "Lançar um raio agora", "Ударить молнией" },
	["Night Mode"] = { "Hacer de noche", "Modo noite", "Ночной режим" },
	["Time"] = { "Hora", "Hora", "Время" },
	["Moonlight"] = { "Luz de luna", "Luz da lua", "Лунный свет" },
	["Stars"] = { "Estrellas", "Estrelas", "Звёзды" },
	["Flashlight"] = { "Linterna", "Lanterna", "Фонарик" },
	["Player Light"] = { "Luz alrededor", "Luz ao redor", "Свет вокруг" },
	["Appearance"] = { "Apariencia", "Aparência", "Внешний вид" },
	["Accent Color"] = { "Color de acento", "Cor de destaque", "Цвет акцента" },
	["Font"] = { "Fuente", "Fonte", "Шрифт" },
	["Roundness"] = { "Redondeo", "Arredondamento", "Скругление" },
	["Animations"] = { "Animaciones", "Animações", "Анимации" },
	["Scroll Step"] = { "Paso de la rueda", "Passo da rolagem", "Шаг прокрутки" },
	["Intro Animation"] = { "Animación de entrada", "Animação de entrada", "Вступительная анимация" },
	["Blur Background"] = { "Desenfocar fondo", "Desfocar fundo", "Размыть фон" },
	["Center Window"] = { "Centrar ventana", "Centralizar janela", "Центрировать окно" },
	["Window"] = { "Ventana", "Janela", "Окно" },
	["Cursor"] = { "Puntero", "Cursor", "Курсор" },
	["Custom Cursor"] = { "Puntero propio", "Cursor personalizado", "Свой курсор" },
	["Controls"] = { "Controles", "Controles", "Управление" },
	["Press a key..."] = { "Pulsa una tecla...", "Pressione uma tecla...", "Нажмите клавишу..." },
	["Open on Join"] = { "Abrir al entrar", "Abrir ao entrar", "Открывать при входе" },
	["Show FPS"] = { "FPS en pantalla", "Mostrar FPS", "Показывать FPS" },
	["Reset"] = { "Restablecer", "Redefinir", "Сброс" },
	["Reset GUI"] = { "Restablecer el GUI", "Redefinir GUI", "Сбросить интерфейс" },
	["Settings stay while you're in the server."] = { "Los ajustes se quedan mientras sigas en el servidor.", "As configurações ficam enquanto você estiver no servidor.", "Настройки сохраняются, пока вы на сервере." },
	["loading lights"] = { "cargando luces", "carregando luzes", "загрузка света" },
	["preparing floors"] = { "preparando pisos", "preparando pisos", "подготовка полов" },
	["tuning colors"] = { "ajustando colores", "ajustando cores", "настройка цветов" },
	["ready"] = { "listo", "pronto", "готово" },
	["Language"] = { "Idioma", "Idioma", "Язык" },
	["Change Key"] = { "Cambiar tecla", "Mudar tecla", "Сменить клавишу" },
	["Keybind"] = { "Tecla", "Tecla", "Клавиша" },
}
local function tr(texto)
	local t = ui.idioma ~= 1 and TRAD[texto]
	return t and t[ui.idioma - 1] or texto
end

local FUENTES = {
	{ "Gotham", Enum.Font.GothamMedium, Enum.Font.GothamBold },
	{ "Montserrat", Enum.Font.Montserrat, Enum.Font.MontserratBold },
	{ "Source Sans", Enum.Font.SourceSans, Enum.Font.SourceSansBold },
	{ "Ubuntu", Enum.Font.Ubuntu, Enum.Font.Ubuntu },
	{ "Arial", Enum.Font.Arial, Enum.Font.ArialBold },
}

local C = {
	fondo = Color3.fromRGB(14, 14, 16),
	lateral = Color3.fromRGB(14, 14, 16),
	tarjeta = Color3.fromRGB(20, 20, 23),
	seleccion = Color3.fromRGB(28, 28, 32),
	borde = Color3.fromRGB(34, 34, 39),
	bordeClaro = Color3.fromRGB(48, 48, 55),
	texto = Color3.fromRGB(226, 226, 230),
	sub = Color3.fromRGB(128, 128, 138),
	tenue = Color3.fromRGB(88, 88, 97),
	pista = Color3.fromRGB(38, 38, 44),
}

local conAcento, conFondo, conTexto, conEsquina, refrescos = {}, {}, {}, {}, {}
local textos = {}

local function nuevo(clase, props, hijos)
	local i = Instance.new(clase)
	for k, v in pairs(props or {}) do
		if k ~= "Parent" then i[k] = v end
	end
	for _, h in ipairs(hijos or {}) do h.Parent = i end
	if props and props.Parent then i.Parent = props.Parent end
	if i:IsA("TextLabel") or i:IsA("TextButton") or i:IsA("TextBox") then
		table.insert(conTexto, { i, i.Font == Enum.Font.GothamBold })
		if i.Text ~= "" and not i.RichText then textos[i] = { i.Text } end
	end
	return i
end
local function esquina(r)
	local c = nuevo("UICorner", { CornerRadius = UDim.new(0, r * ui.esquinas) })
	table.insert(conEsquina, { c, r })
	return c
end
local function redonda() return nuevo("UICorner", { CornerRadius = UDim.new(1, 0) }) end
local function borde(color) return nuevo("UIStroke", { Color = color or C.borde, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) end
local function acento(inst, prop) table.insert(conAcento, { inst, prop }); inst[prop] = ui.acento end
local function fondo(inst, base)
	table.insert(conFondo, { inst, base or 0 })
	inst.BackgroundTransparency = math.clamp((base or 0) + ui.transparencia, 0, 1)
end
local function etiqueta(props)
	props.BackgroundTransparency = 1
	props.Font = props.Font or Enum.Font.GothamMedium
	props.TextSize = props.TextSize or 12
	props.TextColor3 = props.TextColor3 or C.texto
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	return nuevo("TextLabel", props)
end

local ICONOS = {}
local function trazo(padre, props) local f = nuevo("Frame", props); f.BorderSizePixel = 0; f.Parent = padre; table.insert(ICONOS, f); return f end
local function aro(padre, tam, pos)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(tam, tam), Position = pos or UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5) }, { redonda() })
	local s = nuevo("UIStroke", { Thickness = 1.5, Color = C.sub })
	s.Parent = f
	f.Parent = padre
	return f, s
end

local function rayitos(c, n, radio, largo, grosor)
	local t = {}
	for i = 0, n - 1 do
		local ang = (i / n) * math.pi * 2
		table.insert(t, trazo(c, {
			BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, math.cos(ang) * radio, 0.5, math.sin(ang) * radio),
			Size = UDim2.fromOffset(largo, grosor), Rotation = math.deg(ang),
		}))
	end
	return t
end

local DIBUJOS = {
	inicio = function(c)
		local caja = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 7), Size = UDim2.fromOffset(10, 8) }, { esquina(1) })
		local s = nuevo("UIStroke", { Thickness = 1.5, Color = C.sub, Parent = caja })
		caja.Parent = c
		local t1 = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -3, 0, 4.5), Size = UDim2.fromOffset(8, 1.5), Rotation = -38 })
		local t2 = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 3, 0, 4.5), Size = UDim2.fromOffset(8, 1.5), Rotation = 38 })
		return { s }, { t1, t2 }
	end,
	sol = function(c)
		local _, s = aro(c, 7)
		return { s }, rayitos(c, 8, 6.5, 2.5, 1.5)
	end,
	color = function(c)
		local _, s = aro(c, 13)
		local punto = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -2, 0.5, 0), Size = UDim2.fromOffset(5, 9) })
		nuevo("UICorner", { CornerRadius = UDim.new(1, 0), Parent = punto })
		return { s }, { punto }
	end,
	nube = function(c)
		local _, s1 = aro(c, 8, UDim2.new(0.5, -3, 0.5, 1))
		local _, s2 = aro(c, 10, UDim2.new(0.5, 2, 0.5, -1))
		local base = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0.5, 5), Size = UDim2.fromOffset(13, 1.5) })
		return { s1, s2 }, { base }
	end,
	chispa = function(c)
		local a = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1.5, 13) })
		local b = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(13, 1.5) })
		local d1 = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(7, 1.5), Rotation = 45 })
		local d2 = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(7, 1.5), Rotation = -45 })
		return {}, { a, b, d1, d2 }
	end,
	cuadricula = function(c)
		local f = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(13, 13) }, { esquina(2) })
		local s = nuevo("UIStroke", { Thickness = 1.5, Color = C.sub, Parent = f })
		f.Parent = c
		local v = trazo(f, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0), Size = UDim2.new(0, 1.5, 1, 0) })
		local h = trazo(f, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 1.5) })
		return { s }, { v, h }
	end,
	rombo = function(c)
		local f = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -1), Size = UDim2.fromOffset(9, 9), Rotation = 45 }, { esquina(1) })
		local s = nuevo("UIStroke", { Thickness = 1.5, Color = C.sub, Parent = f })
		f.Parent = c
		local linea = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 1, -2), Size = UDim2.fromOffset(11, 1.5) })
		return { s }, { linea }
	end,
	puntos = function(c)
		local p = {}
		for _, o in ipairs({ { -4, 3 }, { 4, 3 }, { 0, -4 } }) do
			local d = trazo(c, { BackgroundColor3 = C.sub, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, o[1], 0.5, o[2]), Size = UDim2.fromOffset(3.5, 3.5) })
			nuevo("UICorner", { CornerRadius = UDim.new(1, 0), Parent = d })
			table.insert(p, d)
		end
		return {}, p
	end,
	gota = function(c)
		local f = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 1), Size = UDim2.fromOffset(9, 9), Rotation = 45 }, { esquina(1) })
		local s1 = nuevo("UIStroke", { Thickness = 1.5, Color = C.sub, Parent = f })
		f.Parent = c
		local _, s2 = aro(c, 10, UDim2.new(0.5, 0, 0.5, 2))
		return { s1, s2 }, {}
	end,
	engrane = function(c)
		local _, s = aro(c, 8)
		return { s }, rayitos(c, 8, 6, 3, 2.5)
	end,
}

local function icono(padre, nombre)
	local c = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 10, 0.5, 0) })
	c.Parent = padre
	local trazos, rellenos = DIBUJOS[nombre](c)
	return function(color)
		for _, s in ipairs(trazos) do s.Color = color end
		for _, f in ipairs(rellenos) do f.BackgroundColor3 = color end
	end
end

local panelGui = nuevo("ScreenGui", { Name = "Phant0nShader", ResetOnSpawn = false, DisplayOrder = 50, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })

local ventana = nuevo("Frame", {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(760, 440),
	BackgroundColor3 = C.fondo,
	Visible = false,
	ClipsDescendants = true,
}, { esquina(10), borde(C.borde) })
fondo(ventana, 0)
local escala = nuevo("UIScale", { Scale = ui.escala, Parent = ventana })
ventana.Parent = panelGui

local lateral = nuevo("Frame", { Size = UDim2.new(0, 176, 1, 0), BackgroundColor3 = C.lateral, BorderSizePixel = 0 })
fondo(lateral, 0)
lateral.Parent = ventana
nuevo("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = C.borde, BorderSizePixel = 0, Parent = lateral })

-- perfil (arriba a la izquierda)
local foto = nuevo("ImageLabel", { Size = UDim2.fromOffset(36, 36), Position = UDim2.fromOffset(16, 16), BackgroundColor3 = C.seleccion }, { redonda() })
foto.Parent = lateral
task.spawn(function()
	local ok, img = pcall(function()
		return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if ok then foto.Image = img end
end)
etiqueta({ Text = player.DisplayName, Font = Enum.Font.GothamBold, TextSize = 13, Position = UDim2.fromOffset(60, 17), Size = UDim2.new(1, -70, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd, Parent = lateral })
local nombreJuego = etiqueta({ Text = "Shader", TextSize = 11, TextColor3 = C.sub, Position = UDim2.fromOffset(60, 34), Size = UDim2.new(1, -70, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd, Parent = lateral })
textos[nombreJuego] = nil
task.spawn(function()
	local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
	if ok and info and info.Name and info.Name ~= "" then nombreJuego.Text = info.Name end
end)

local scrollTabs = nuevo("ScrollingFrame", {
	BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.fromOffset(10, 66), Size = UDim2.new(1, -14, 1, -76),
	CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 2,
	ScrollBarImageColor3 = C.bordeClaro, ScrollingDirection = Enum.ScrollingDirection.Y,
})
scrollTabs.Parent = lateral
local listaTabs = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 3 }, {
	nuevo("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }),
	nuevo("UIPadding", { PaddingBottom = UDim.new(0, 10) }),
})
listaTabs.Parent = scrollTabs

-- barra superior
local arriba = nuevo("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(177, 0), Size = UDim2.new(1, -177, 0, 50) })
arriba.Parent = ventana
nuevo("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = C.borde, BorderSizePixel = 0, Parent = arriba })

local tituloPagina = etiqueta({ Text = "Home", Font = Enum.Font.GothamBold, TextSize = 13, Position = UDim2.fromOffset(18, 0), Size = UDim2.new(0, 104, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = arriba })

-- buscador con lupa
local cajaBuscar = nuevo("Frame", { BackgroundColor3 = C.tarjeta, Position = UDim2.fromOffset(126, 11), Size = UDim2.fromOffset(156, 28) }, { esquina(6), borde() })
fondo(cajaBuscar, 0)
cajaBuscar.Parent = arriba
do
	local lupa = nuevo("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(9, 8), Size = UDim2.fromOffset(9, 9) }, { redonda(), nuevo("UIStroke", { Thickness = 1.5, Color = C.sub }) })
	lupa.Parent = cajaBuscar
	nuevo("Frame", { BackgroundColor3 = C.sub, BorderSizePixel = 0, Position = UDim2.fromOffset(16, 17), Size = UDim2.fromOffset(5, 1.5), Rotation = 45, Parent = cajaBuscar })
end
local buscador = nuevo("TextBox", {
	PlaceholderText = "Search settings...", Text = "", ClearTextOnFocus = false,
	Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.texto, PlaceholderColor3 = C.tenue,
	TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1,
	Position = UDim2.fromOffset(28, 0), Size = UDim2.new(1, -34, 1, 0),
})
buscador.Parent = cajaBuscar

-- derecha: marca, keybind, minimizar, cerrar
local derecha = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X }, {
	nuevo("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }),
})
derecha.Parent = arriba

local marca = etiqueta({ RichText = true, Text = "", Font = Enum.Font.GothamBold, TextSize = 13, Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Right, LayoutOrder = 1, Parent = derecha })
local function pintarMarca()
	local r, g, b = math.floor(ui.acento.R * 255), math.floor(ui.acento.G * 255), math.floor(ui.acento.B * 255)
	marca.Text = string.format('%s <font color="rgb(%d,%d,%d)">%s</font>', ui.titulo, r, g, b, ui.subtitulo)
end
local teclaTexto = etiqueta({ RichText = true, Text = "", TextSize = 11, TextColor3 = C.sub, Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Right, LayoutOrder = 2, Parent = derecha })
local function pintarTecla()
	teclaTexto.Text = tr("Keybind") .. '  <font color="rgb(226,226,230)">' .. ui.tecla.Name .. "</font>"
end
local minimizar = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(22, 22), LayoutOrder = 3, Parent = derecha })
nuevo("Frame", { BackgroundColor3 = C.sub, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(10, 1.5), Parent = minimizar })
local cerrar = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromOffset(22, 22), LayoutOrder = 4, Parent = derecha })
for _, rot in ipairs({ 45, -45 }) do
	nuevo("Frame", { BackgroundColor3 = C.sub, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(12, 1.5), Rotation = rot, Parent = cerrar })
end

local zona = nuevo("Frame", { BackgroundTransparency = 1, Position = UDim2.fromOffset(177, 50), Size = UDim2.new(1, -177, 1, -50) })
zona.Parent = ventana

-- arrastrar desde la barra superior
do
	local arrastrando, inicio, posInicio = false, nil, nil
	local function dentro(g, p)
		local a, t = g.AbsolutePosition, g.AbsoluteSize
		return p.X >= a.X and p.Y >= a.Y and p.X <= a.X + t.X and p.Y <= a.Y + t.Y
	end
	UserInputService.InputBegan:Connect(function(i)
		if not ventana.Visible then return end
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local p = Vector2.new(i.Position.X, i.Position.Y)
		local enPerfil = dentro(lateral, p) and p.Y <= lateral.AbsolutePosition.Y + 60 * (lateral.AbsoluteSize.X / 176)
		if (dentro(arriba, p) or enPerfil) and not dentro(cajaBuscar, p) and not dentro(minimizar, p) and not dentro(cerrar, p) then
			arrastrando, inicio, posInicio = true, i.Position, ventana.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if arrastrando and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - inicio
			ventana.Position = UDim2.new(posInicio.X.Scale, posInicio.X.Offset + d.X, posInicio.Y.Scale, posInicio.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then arrastrando = false end
	end)
end

local blurFondo = Instance.new("BlurEffect")
blurFondo.Name = "Phant0nPanelBlur"
blurFondo.Size = 0
blurFondo.Parent = workspace.CurrentCamera

local animando = false
local function tween(obj, t, props, estilo, dir)
	local dur = ui.animaciones and (t / math.max(ui.velocidadAnim, 0.1)) or 0
	local x = TweenService:Create(obj, TweenInfo.new(dur, estilo or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	x:Play()
	return x
end

local alAbrir, alCerrar = {}, {}

local function abrirPanel()
	if animando or ventana.Visible then return end
	ventana.Visible = true
	if blurFondo.Parent ~= workspace.CurrentCamera then blurFondo.Parent = workspace.CurrentCamera end
	if ui.desenfocarFondo then tween(blurFondo, 0.45, { Size = 10 }, Enum.EasingStyle.Sine) end
	-- entra subiendo un poquito y creciendo suave
	local pos = ventana.Position
	ventana.Position = pos + UDim2.fromOffset(0, 22)
	escala.Scale = ui.escala * 0.94
	tween(ventana, 0.45, { Position = pos })
	tween(escala, 0.45, { Scale = ui.escala })
	for _, f in ipairs(alAbrir) do task.spawn(f) end
end

local function cerrarPanel()
	if animando or not ventana.Visible then return end
	animando = true
	for _, f in ipairs(alCerrar) do task.spawn(f) end
	tween(blurFondo, 0.3, { Size = 0 }, Enum.EasingStyle.Sine)
	local pos = ventana.Position
	tween(ventana, 0.22, { Position = pos + UDim2.fromOffset(0, 16) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	local t = tween(escala, 0.22, { Scale = ui.escala * 0.94 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	if ui.animaciones then t.Completed:Wait() end
	ventana.Visible = false
	ventana.Position = pos
	escala.Scale = ui.escala
	animando = false
end

local function alternarPanel()
	if ventana.Visible then task.spawn(cerrarPanel) else abrirPanel() end
end
cerrar.MouseButton1Click:Connect(function() task.spawn(cerrarPanel) end)
minimizar.MouseButton1Click:Connect(function() task.spawn(cerrarPanel) end)

local paginas, filas = {}, {}
local paginaActual
local moverIndicador

local cursorEstado = { encima = nil, presionado = false }
local function marcarEncima(b)
	b.MouseEnter:Connect(function() cursorEstado.encima = b end)
	b.MouseLeave:Connect(function() if cursorEstado.encima == b then cursorEstado.encima = nil end end)
end

local function presionable(b, normal, encima)
	local sc = Instance.new("UIScale")
	sc.Parent = b
	marcarEncima(b)
	b.MouseEnter:Connect(function()
		if encima then tween(b, 0.25, { BackgroundColor3 = encima }, Enum.EasingStyle.Sine) end
	end)
	b.MouseLeave:Connect(function()
		if normal then tween(b, 0.3, { BackgroundColor3 = normal }, Enum.EasingStyle.Sine) end
		tween(sc, 0.3, { Scale = 1 })
	end)
	b.MouseButton1Down:Connect(function() tween(sc, 0.12, { Scale = 0.94 }, Enum.EasingStyle.Quad) end)
	b.MouseButton1Up:Connect(function() tween(sc, 0.45, { Scale = 1 }, Enum.EasingStyle.Back) end)
	return sc
end

local veloPagina = nuevo("Frame", { Name = "Velo", BackgroundColor3 = C.fondo, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 20, Visible = false })
veloPagina.Parent = zona

local function crearPagina(nombre)
	local scroll = nuevo("ScrollingFrame", {
		Name = nombre, BackgroundTransparency = 1, BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1), CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2, ScrollBarImageColor3 = C.bordeClaro, Visible = false,
	}, { nuevo("UIPadding", { PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingBottom = UDim.new(0, 16) }) })
	local cols = {}
	for c = 1, 2 do
		cols[c] = nuevo("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new((c - 1) * 0.5, c == 2 and 7 or 0, 0, 0),
			Size = UDim2.new(0.5, -7, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		}, { nuevo("UIListLayout", { Padding = UDim.new(0, 12), SortOrder = Enum.SortOrder.LayoutOrder }) })
		cols[c].Parent = scroll
	end
	scroll.Parent = zona
	-- y lo llevamos hasta ahí con una curva suave
	local sv = { objetivo = 0, mostrado = 0, ultimo = 0 }
	scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		local y = scroll.CanvasPosition.Y
		if math.abs(y - sv.ultimo) < 0.01 then return end
		local ultimo = UserInputService:GetLastInputType()
		if not (ui.scrollSuave and ui.animaciones) or ultimo == Enum.UserInputType.Touch then
			sv.objetivo, sv.mostrado, sv.ultimo = y, y, y
			return
		end
		local d = y - sv.ultimo
		if ultimo == Enum.UserInputType.MouseWheel then d *= ui.pasoRueda end
		local f = scroll.AbsoluteSize.Y > 0 and (scroll.AbsoluteSize.Y / 390) or 1
		local maxY = math.max(0, (scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y) / math.max(f, 0.01))
		sv.objetivo = math.clamp(sv.objetivo + d, 0, maxY)
		sv.ultimo = math.floor(sv.mostrado + 0.5)
		scroll.CanvasPosition = Vector2.new(0, sv.ultimo)
	end)
	paginas[nombre] = { scroll = scroll, cols = cols, n = 0, suave = sv }
	return paginas[nombre]
end

local function grupo(pagina, titulo, columna)
	pagina.n += 1
	local g = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = pagina.n }, {
		nuevo("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	local cab = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1 })
	etiqueta({ Text = titulo, Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, -20, 1, 0), Parent = cab })
	local flecha = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -2, 0.5, 0), Size = UDim2.fromOffset(10, 10), Parent = cab })
	for i, rot in ipairs({ 45, -45 }) do
		nuevo("Frame", { BackgroundColor3 = C.sub, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, i == 1 and -2 or 2, 0.5, 0), Size = UDim2.fromOffset(6, 1.5), Rotation = rot, Parent = flecha })
	end
	cab.Parent = g
	marcarEncima(cab)
	local tarjeta = nuevo("Frame", { BackgroundColor3 = C.tarjeta, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = 2 }, {
		esquina(8), borde(),
		nuevo("UIListLayout", { Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder }),
		nuevo("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
	})
	fondo(tarjeta, 0)
	tarjeta.Parent = g
	cab.MouseButton1Click:Connect(function()
		tarjeta.Visible = not tarjeta.Visible
		tween(flecha, 0.2, { Rotation = tarjeta.Visible and 0 or -90 })
	end)
	g.Parent = pagina.cols[columna or ((pagina.n - 1) % 2 + 1)]
	return { cuerpo = tarjeta, pagina = pagina, n = 0 }
end

local function fila(gr, frame, texto)
	gr.n += 1
	frame.LayoutOrder = gr.n
	frame.Parent = gr.cuerpo
	table.insert(filas, { frame, texto, gr.pagina })
end

local deslizando = nil
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then deslizando = nil end
end)
UserInputService.InputChanged:Connect(function(i)
	if deslizando and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
		deslizando(i.Position.X)
	end
end)

local function slider(gr, texto, min, max, paso, leer, escribir, decimales)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42) })
	etiqueta({ Text = texto, Size = UDim2.new(1, -60, 0, 22), Parent = f })
	local valor = etiqueta({ Text = "", TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Right, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 60, 0, 22), Parent = f })
	local pista = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = C.pista, BorderSizePixel = 0, Position = UDim2.fromOffset(0, 27), Size = UDim2.new(1, 0, 0, 6) }, { redonda() })
	local relleno = nuevo("Frame", { BorderSizePixel = 0, Size = UDim2.fromScale(0, 1) }, { redonda() })
	acento(relleno, "BackgroundColor3")
	relleno.Parent = pista
	local perilla = nuevo("Frame", { BackgroundColor3 = C.texto, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(11, 11), ZIndex = 2 }, { redonda(), borde(C.fondo) })
	perilla.Parent = pista
	pista.Parent = f
	marcarEncima(pista)
	pista.MouseEnter:Connect(function() tween(perilla, 0.25, { Size = UDim2.fromOffset(15, 15) }, Enum.EasingStyle.Back) end)
	pista.MouseLeave:Connect(function() if deslizando == nil then tween(perilla, 0.25, { Size = UDim2.fromOffset(11, 11) }) end end)
	decimales = decimales or (paso < 0.1 and 2 or (paso < 1 and 1 or 0))
	local function pintar(v)
		local a = math.clamp((v - min) / (max - min), 0, 1)
		tween(relleno, 0.18, { Size = UDim2.fromScale(a, 1) })
		tween(perilla, 0.18, { Position = UDim2.fromScale(a, 0.5) })
		local t = string.format("%." .. decimales .. "f", v)
		if valor.Text ~= t then
			valor.Text = t
			valor.TextColor3 = C.texto
			tween(valor, 0.5, { TextColor3 = C.sub }, Enum.EasingStyle.Sine)
		end
	end
	local function desdeX(x)
		local a = math.clamp((x - pista.AbsolutePosition.X) / pista.AbsoluteSize.X, 0, 1)
		local v = math.clamp(math.floor((min + a * (max - min)) / paso + 0.5) * paso, min, max)
		escribir(v)
		pintar(v)
	end
	pista.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			deslizando = desdeX
			desdeX(i.Position.X)
		end
	end)
	pintar(leer())
	table.insert(refrescos, function() pintar(leer()) end)
	fila(gr, f, texto)
end

local function interruptor(gr, texto, leer, escribir)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30) })
	etiqueta({ Text = texto, Size = UDim2.new(1, -60, 1, 0), Parent = f })
	local caja = nuevo("TextButton", { Text = "", AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(32, 16), BackgroundColor3 = C.pista }, { redonda() })
	local bolita = nuevo("Frame", { AnchorPoint = Vector2.new(0, 0.5), Size = UDim2.fromOffset(10, 10), BackgroundColor3 = C.sub }, { redonda() })
	bolita.Parent = caja
	caja.Parent = f
	presionable(caja)
	local function pintar(v)
		tween(bolita, 0.3, { Position = v and UDim2.new(1, -13, 0.5, 0) or UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = v and C.fondo or C.sub }, Enum.EasingStyle.Back)
		tween(caja, 0.3, { BackgroundColor3 = v and ui.acento or C.pista }, Enum.EasingStyle.Sine)
	end
	caja.MouseButton1Click:Connect(function()
		local v = not leer()
		escribir(v)
		pintar(v)
	end)
	pintar(leer())
	table.insert(refrescos, function() pintar(leer()) end)
	fila(gr, f, texto)
end

local function selector(gr, texto, opciones, leer, escribir)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30) })
	etiqueta({ Text = texto, Size = UDim2.new(1, -110, 1, 0), Parent = f })
	local b = nuevo("TextButton", {
		Text = "", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = C.sub,
		AutoButtonColor = false, BackgroundColor3 = C.seleccion,
		AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(100, 22),
	}, { esquina(5), borde() })
	b.Parent = f
	presionable(b, C.seleccion, C.bordeClaro)
	local function pintar() b.Text = tr(opciones[leer()] or "?") end
	b.MouseButton1Click:Connect(function()
		local i = leer() + 1
		if i > #opciones then i = 1 end
		escribir(i)
		pintar()
		-- el texto nuevo aparece suave
		b.TextTransparency = 1
		b.TextColor3 = C.texto
		tween(b, 0.35, { TextTransparency = 0 }, Enum.EasingStyle.Sine)
		tween(b, 0.6, { TextColor3 = C.sub }, Enum.EasingStyle.Sine)
	end)
	pintar()
	table.insert(refrescos, pintar)
	fila(gr, f, texto)
	return b
end

local function colores(gr, texto, opciones, leer, escribir)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30) })
	etiqueta({ Text = texto, Size = UDim2.new(0.42, 0, 1, 0), Parent = f })
	local filaC = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0.58, 0, 0, 14) }, {
		nuevo("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6) }),
	})
	filaC.Parent = f
	local botones = {}
	local function pintar()
		local actual = leer()
		for _, b in ipairs(botones) do
			local sel = (b[1].BackgroundColor3 == actual)
			tween(b[2], 0.25, { Transparency = sel and 0 or 1 }, Enum.EasingStyle.Sine)
			tween(b[1], 0.3, { Size = sel and UDim2.fromOffset(16, 16) or UDim2.fromOffset(14, 14) }, Enum.EasingStyle.Back)
		end
	end
	for _, col in ipairs(opciones) do
		local b = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = col, Size = UDim2.fromOffset(14, 14) }, { esquina(3) })
		local st = nuevo("UIStroke", { Color = C.texto, Thickness = 1.5 })
		st.Parent = b
		b.Parent = filaC
		presionable(b)
		table.insert(botones, { b, st })
		b.MouseButton1Click:Connect(function() escribir(col); pintar() end)
	end
	pintar()
	table.insert(refrescos, pintar)
	fila(gr, f, texto)
end

local function boton(gr, texto, accion)
	local f = nuevo("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 34) })
	local b = nuevo("TextButton", {
		Text = texto, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = C.texto,
		AutoButtonColor = false, BackgroundColor3 = C.seleccion,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 18), Size = UDim2.new(1, 0, 0, 28),
	}, { esquina(6), borde() })
	presionable(b, C.seleccion, C.bordeClaro)
	b.Parent = f
	b.MouseButton1Click:Connect(accion)
	fila(gr, f, texto)
	return b
end

local function nota(gr, contenido)
	local f = etiqueta({ Text = contenido, TextSize = 11, TextColor3 = C.sub, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y })
	local pad = nuevo("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) })
	pad.Parent = f
	fila(gr, f, contenido)
	return f
end

-- atajos para leer/escribir el shader
local function G(campo, despues)
	return function() return gfx[campo] end, function(v) gfx[campo] = v; (despues or aplicarGraficos)() end
end
local function R(campo)
	return function() return ref[campo] end, function(v) ref[campo] = v; actualizarReflejo() end
end

local tabs, orden = {}, 0
local function seccion(nombre)
	orden += 1
	local l = etiqueta({ Text = nombre, Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = C.tenue, Size = UDim2.new(1, 0, 0, 26), LayoutOrder = orden })
	nuevo("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingTop = UDim.new(0, 8), Parent = l })
	textos[l] = { nombre, true }
	l.Text = string.upper(nombre)
	l.Parent = listaTabs
end

local function mostrarPagina(nombre)
	local cambio = (paginaActual ~= nombre)
	paginaActual = nombre
	tituloPagina.Text = tr(nombre)
	for n, p in pairs(paginas) do
		local ver = (n == nombre)
		if ver and cambio and ventana.Visible and ui.animaciones then
			p.scroll.Position = UDim2.fromOffset(0, 16)
			tween(p.scroll, 0.45, { Position = UDim2.new() })
			veloPagina.BackgroundColor3 = C.fondo
			veloPagina.BackgroundTransparency = math.clamp(ui.transparencia, 0, 1)
			veloPagina.Visible = true
			local tv = tween(veloPagina, 0.35, { BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
			tv.Completed:Once(function(estado)
				if estado == Enum.PlaybackState.Completed then veloPagina.Visible = false end
			end)
			tituloPagina.TextTransparency = 1
			tween(tituloPagina, 0.4, { TextTransparency = 0 }, Enum.EasingStyle.Sine)
		elseif ver then
			p.scroll.Position = UDim2.new()
		end
		p.scroll.Visible = ver
	end
	for n, t in pairs(tabs) do
		local sel = (n == nombre)
		t.boton.BackgroundTransparency = 1
		t.borde.Enabled = false
		tween(t.texto, 0.3, { TextColor3 = sel and C.texto or C.sub, Position = UDim2.fromOffset(sel and 38 or 34, 0) })
		t.pintarIcono(sel and ui.acento or C.sub)
	end
	if moverIndicador then moverIndicador(not ventana.Visible) end
	buscador.Text = ""
end

local function tab(nombre, dibujo, padre)
	orden += 1
	local b = nuevo("TextButton", { Text = "", AutoButtonColor = false, BackgroundColor3 = C.seleccion, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = orden }, { esquina(7) })
	local st = borde(C.bordeClaro)
	st.Parent = b
	st.Enabled = false
	local pintarIcono = icono(b, dibujo)
	local t = etiqueta({ Text = nombre, TextColor3 = C.sub, Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -38, 1, 0), Parent = b })
	b.Parent = padre or listaTabs
	tabs[nombre] = { boton = b, borde = st, texto = t, pintarIcono = pintarIcono }
	marcarEncima(b)
	b.MouseEnter:Connect(function()
		if paginaActual ~= nombre then tween(t, 0.25, { TextColor3 = C.texto, Position = UDim2.fromOffset(37, 0) }, Enum.EasingStyle.Sine) end
	end)
	b.MouseLeave:Connect(function()
		if paginaActual ~= nombre then tween(t, 0.3, { TextColor3 = C.sub, Position = UDim2.fromOffset(34, 0) }, Enum.EasingStyle.Sine) end
	end)
	b.MouseButton1Click:Connect(function() mostrarPagina(nombre) end)
end

seccion("General")
tab("Home", "inicio")
seccion("Shader")
tab("Lighting", "sol")
tab("Color", "color")
tab("Atmosphere", "nube")
tab("Effects", "chispa")
seccion("Surfaces")
tab("Floors & Glass", "cuadricula")
tab("Reflection", "rombo")
seccion("Ambient")
tab("Particles", "puntos")
tab("Weather", "gota")
seccion("Skys")
tab("Skyboxes", "nube")

seccion("Panel")
tab("Settings", "engrane")

do
	local indicador = nuevo("Frame", { Name = "Indicador", BackgroundColor3 = C.seleccion, BorderSizePixel = 0, Size = UDim2.fromOffset(156, 32), ZIndex = 2 }, { esquina(7), borde(C.bordeClaro) })
	indicador.Parent = scrollTabs
	local barrita = nuevo("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 5, 0.5, 0), Size = UDim2.fromOffset(3, 14), ZIndex = 2 }, { redonda() })
	acento(barrita, "BackgroundColor3")
	barrita.Parent = indicador
	local ultimoTab
	moverIndicador = function(instantaneo)
		local t = tabs[paginaActual]
		if not t then return end
		local f = lateral.AbsoluteSize.X / 176
		if f <= 0 then return end
		local rel = (t.boton.AbsolutePosition - listaTabs.AbsolutePosition) / f
		local tam = t.boton.AbsoluteSize / f
		local props = { Position = UDim2.fromOffset(rel.X, rel.Y), Size = UDim2.fromOffset(tam.X, tam.Y) }
		if instantaneo or not ui.animaciones then
			indicador.Position, indicador.Size = props.Position, props.Size
		else
			tween(indicador, 0.42, props)
			if ultimoTab ~= paginaActual then
				barrita.Size = UDim2.fromOffset(3, 4)
				tween(barrita, 0.5, { Size = UDim2.fromOffset(3, 14) }, Enum.EasingStyle.Back)
			end
		end
		ultimoTab = paginaActual
	end
	table.insert(alAbrir, function()
		RunService.RenderStepped:Wait()
		moverIndicador(true)
	end)
end

local PRESETS = {
	{ "Cinematic", {
		noche = false, aurora = false, lluvia = false, tormenta = false, linterna = false,
		hora = 16.4, latitud = 35, brillo = 2.7, exposicion = -0.05, sombraSuavidad = 0.08,
		ambiente = Color3.fromRGB(78, 74, 70), ambienteExterior = Color3.fromRGB(132, 125, 118),
		atmDensidad = 0.3, atmOffset = 0.1, atmHaze = 1.2, atmGlare = 0.9,
		atmColor = Color3.fromRGB(192, 180, 162), atmDecay = Color3.fromRGB(112, 96, 80), nieblaCercana = 0.1,
		saturacion = 0.35, contraste = 0.22, brilloColor = -0.02, tinte = Color3.fromRGB(255, 247, 236),
		bloomIntensidad = 0.3, bloomTamano = 30, bloomUmbral = 1.3, rayosIntensidad = 0.12, rayosAlcance = 1,
		lejosBorroso = true, lejosIntensidad = 0.28, lejosFoco = 60, lejosRadio = 70, cercaIntensidad = 0,
		vineta = true, vinetaFuerza = 0.38, nubes = false,
		polvo = true, polvoCantidad = 80, destellosCantidad = 20, arenaCantidad = 10, polvoColor = Color3.fromRGB(255, 236, 205),
		destelloSol = true, destelloFuerza = 0.6, solRealista = true, solBrillo = 1, solTamano = 0.9, remolinos = true, brisa = 0.5, pastoViento = true, pastoFuerza = 0.8,
		luciernagas = 0, nieblaBaja = 0,
	} },
	{ "Sunset", {
		noche = false, aurora = false, lluvia = false, tormenta = false, linterna = false,
		hora = 17.45, latitud = 28, brillo = 3.2, exposicion = 0.1, sombraSuavidad = 0.05,
		ambiente = Color3.fromRGB(66, 52, 50), ambienteExterior = Color3.fromRGB(118, 92, 84),
		atmDensidad = 0.32, atmOffset = 0.18, atmHaze = 1.6, atmGlare = 1.4,
		atmColor = Color3.fromRGB(225, 170, 130), atmDecay = Color3.fromRGB(125, 75, 60), nieblaCercana = 0.1,
		saturacion = 0.2, contraste = 0.3, brilloColor = -0.02, tinte = Color3.fromRGB(255, 232, 206),
		bloomIntensidad = 0.55, bloomTamano = 36, bloomUmbral = 0.95, rayosIntensidad = 0.2, rayosAlcance = 0.9,
		lejosBorroso = true, lejosIntensidad = 0.4, lejosFoco = 40, lejosRadio = 45, cercaIntensidad = 0.12,
		vineta = true, vinetaFuerza = 0.5, nubes = true,
		polvo = true, polvoCantidad = 60, destellosCantidad = 40, arenaCantidad = 4, polvoColor = Color3.fromRGB(255, 214, 170),
		destelloSol = true, destelloFuerza = 0.7, remolinos = false, brisa = 0.35, pastoViento = true, pastoFuerza = 0.6,
		solRealista = true, solBrillo = 1.2, solTamano = 1,
		luciernagas = 0, nieblaBaja = 3, nieblaBajaColor = Color3.fromRGB(255, 205, 175),
	} },
	{ "Night", {
		noche = true, aurora = false, lluvia = false, tormenta = false, linterna = false, luzJugador = true,
		nocheHora = 0.5, nocheLuna = 2.2, nocheExposicion = 0.8, nocheEstrellas = 4000,
		nocheAmbiente = Color3.fromRGB(72, 80, 104), nocheExterior = Color3.fromRGB(112, 124, 158), nocheTinte = Color3.fromRGB(205, 218, 255),
		atmHaze = 1, nieblaCercana = 0.08,
		saturacion = 0.35, contraste = 0.18, brilloColor = 0, bloomIntensidad = 0.6, bloomTamano = 32,
		lejosBorroso = true, lejosIntensidad = 0.2, lejosFoco = 50, lejosRadio = 60, cercaIntensidad = 0,
		vineta = true, vinetaFuerza = 0.3, nubes = false, polvo = false,
		destelloSol = false, solRealista = false, remolinos = false, brisa = 0.25, pastoViento = true, pastoFuerza = 0.6,
		luciernagas = 35, nieblaBaja = 5, nieblaBajaColor = Color3.fromRGB(150, 165, 200),
	} },
	{ "Aurora", {
		noche = true, aurora = true, lluvia = false, tormenta = false, luzJugador = true, linterna = false,
		nocheHora = 0.5, nocheLuna = 1.7, nocheExposicion = 0.6, nocheEstrellas = 7000, nocheTinte = Color3.fromRGB(210, 232, 255),
		nocheAmbiente = Color3.fromRGB(62, 76, 96), nocheExterior = Color3.fromRGB(96, 118, 148),
		auroraIntensidad = 1, auroraVelocidad = 1, auroraRojo = 0.5, auroraSubtormentas = true, auroraFugaces = true, auroraEscarcha = true,
		auroraBandas = true, auroraRayos = 0.55,
		nieblaCercana = 0.04, saturacion = 0.5, contraste = 0.2, brilloColor = 0, bloomIntensidad = 1.15, bloomTamano = 44, bloomUmbral = 0.62,
		vineta = true, vinetaFuerza = 0.35, polvo = false, lejosBorroso = false, cercaIntensidad = 0, nubes = false,
		destelloSol = false, solRealista = false, remolinos = false, brisa = 0.15, pastoViento = true, pastoFuerza = 0.4,
		luciernagas = 0, nieblaBaja = 2, nieblaBajaColor = Color3.fromRGB(170, 200, 210),
	} },
	{ "Thunderstorm", {
		lluvia = true, tormenta = true, noche = false, aurora = false, relampagos = true, linterna = false,
		hora = 14, brillo = 2.8, exposicion = 0.15, sombraSuavidad = 0.85,
		saturacion = 0.1, contraste = 0.24, brilloColor = 0.02,
		lluviaIntensidad = 6000, lluviaSalpicaduras = 450, lluviaViento = 26,
		lluviaVelocidad = 165, lluviaEstirar = 2.8, lluviaOscurecer = 0.6,
		tormentaRayosMin = 2, tormentaRayosMax = 7, tormentaATierra = 0.45,
		tormentaRafagas = 0.75, tormentaCortinas = 9, nieblaCercana = 0.3,
		lluviaCerca = 1600, lluviaLente = true, lluviaNeblinaSuelo = 10, tormentaEscombros = 18,
		pastoViento = true, pastoFuerza = 1.4,
		bloomIntensidad = 0.55, bloomTamano = 28, bloomUmbral = 0.9, rayosIntensidad = 0,
		lejosBorroso = true, lejosIntensidad = 0.4, lejosFoco = 35, lejosRadio = 40, cercaIntensidad = 0.1,
		vineta = true, vinetaFuerza = 0.4, polvo = false,
		mojadoReflectance = 0.6, vidrioReflectance = 0.75, barnizFuerza = 0.45,
		destelloSol = false, solRealista = false, remolinos = false, luciernagas = 0, nieblaBaja = 0,
	} },
}
local REFLEJOSO = {
	pisosBrillantes = true, superficiesBrillantes = true,
	pisoReflectance = 0.35, pisoMojado = true, mojadoReflectance = 0.5, mojadoOscurecer = 0.15,
	pisoVidrio = true, vidrioTransparencia = 0.5, vidrioReflectance = 0.65,
	paredReflectance = 0.22, barniz = true, barnizFuerza = 0.35, mojadoBarniz = 0.55,
	aguaReflejo = true,
}
local ORIGINAL, ORIGINAL_REF, ORIGINAL_UI = {}, {}, {}
for k, v in pairs(sinShader.original) do ORIGINAL[k] = v end
for k, v in pairs(ref) do ORIGINAL_REF[k] = v end
for k, v in pairs(ui) do ORIGINAL_UI[k] = v end

local function refrescarTodo() for _, f in ipairs(refrescos) do f() end end

local fpsEtiqueta
do
	local pg = crearPagina("Home")
	local g1 = grupo(pg, "Presets", 1)
	PRESETS.aplicar = function(p)
		if sinShader.activo then
			sinShader.activo = false
			table.clear(sinShader.apagados)
		end
		-- cada preset arranca desde cero: nada del preset anterior se queda mezclado
		local sky, giro, vel = gfx.skybox, gfx.skyGiro, gfx.skyVelocidad
		for k, v in pairs(ORIGINAL) do gfx[k] = v end
		gfx.skybox, gfx.skyGiro, gfx.skyVelocidad = sky, giro, vel
		for k, v in pairs(REFLEJOSO) do gfx[k] = v end
		for k, v in pairs(p[2]) do gfx[k] = v end
		ref.activado = true
		aplicarTodo()
		refrescarTodo()
	end
	for _, p in ipairs(PRESETS) do
		boton(g1, p[1], function() PRESETS.aplicar(p) end)
	end
	boton(g1, "Reset to Default", function()
		-- quita el preset: el mapa vuelve a verse normal (el cielo elegido se queda)
		for k, v in pairs(ORIGINAL_REF) do ref[k] = v end
		if not sinShader.activo then alternarShader() end
		refrescarTodo()
	end)
	local g2 = grupo(pg, "Info", 2)
	fpsEtiqueta = nota(g2, "FPS: --")
	textos[fpsEtiqueta] = nil
	nota(g2, "Press K to hide or show this panel.")
	nota(g2, "Floors and glass shine a lot more with Lighting > Technology set to Future.")
end

do
	local pg = crearPagina("Lighting")
	local g1 = grupo(pg, "Sun", 1)
	slider(g1, "Time of Day", 0, 24, 0.1, G("hora"))
	slider(g1, "Sun Direction", -90, 90, 1, G("latitud"))
	slider(g1, "Brightness", 0, 6, 0.05, G("brillo"))
	slider(g1, "Exposure", -2, 2, 0.05, G("exposicion"))
	local g2 = grupo(pg, "Shadows", 2)
	slider(g2, "Softness", 0, 1, 0.01, G("sombraSuavidad"))
	slider(g2, "Shadow Fill", 0, 1, 0.01, G("rellenoSombra"))
	colores(g2, "Ambient", { Color3.fromRGB(60, 57, 54), Color3.fromRGB(40, 40, 48), Color3.fromRGB(85, 80, 75), Color3.fromRGB(60, 70, 90), Color3.fromRGB(20, 20, 22) }, G("ambiente"))
	colores(g2, "Outdoor", { Color3.fromRGB(95, 90, 86), Color3.fromRGB(128, 128, 140), Color3.fromRGB(150, 120, 100), Color3.fromRGB(90, 110, 140), Color3.fromRGB(50, 50, 55) }, G("ambienteExterior"))
end

do
	local pg = crearPagina("Color")
	local g1 = grupo(pg, "Correction", 1)
	slider(g1, "Saturation", -1, 1, 0.01, G("saturacion"))
	slider(g1, "Contrast", -1, 1, 0.01, G("contraste"))
	slider(g1, "Brightness", -0.5, 0.5, 0.01, G("brilloColor"))
	local g2 = grupo(pg, "Tint", 2)
	colores(g2, "Tone", { Color3.fromRGB(255, 252, 248), Color3.fromRGB(255, 236, 214), Color3.fromRGB(220, 235, 255), Color3.fromRGB(255, 225, 240), Color3.fromRGB(225, 255, 230) }, G("tinte"))
end

do
	local pg = crearPagina("Atmosphere")
	local g1 = grupo(pg, "Mist", 1)
	slider(g1, "Density", 0, 1, 0.01, G("atmDensidad"))
	slider(g1, "Haze", 0, 10, 0.05, G("atmHaze"))
	slider(g1, "Glare", 0, 10, 0.05, G("atmGlare"))
	slider(g1, "Height", 0, 1, 0.01, G("atmOffset"))
	slider(g1, "Near Fog", 0, 1, 0.01, G("nieblaCercana"))
	local g2 = grupo(pg, "Sky", 2)
	interruptor(g2, "Remove Fog", G("quitarNiebla"))
	interruptor(g2, "Clear Sky", G("cieloClaro"))
	interruptor(g2, "Clouds", G("nubes"))
	colores(g2, "Color", { Color3.fromRGB(170, 163, 152), Color3.fromRGB(199, 222, 255), Color3.fromRGB(230, 190, 160), Color3.fromRGB(200, 200, 205), Color3.fromRGB(150, 170, 200) }, G("atmColor"))
end

do
	local pg = crearPagina("Effects")
	local g1 = grupo(pg, "Bloom", 1)
	slider(g1, "Intensity", 0, 2, 0.01, G("bloomIntensidad"))
	slider(g1, "Size", 0, 56, 1, G("bloomTamano"))
	slider(g1, "Threshold", 0.5, 3, 0.01, G("bloomUmbral"))
	local g2 = grupo(pg, "Sun Rays", 2)
	slider(g2, "Intensity", 0, 1, 0.01, G("rayosIntensidad"))
	slider(g2, "Spread", 0, 1, 0.01, G("rayosAlcance"))
	local g3 = grupo(pg, "Depth", 1)
	interruptor(g3, "Far Blur", G("lejosBorroso"))
	slider(g3, "Intensity", 0, 1, 0.01, G("lejosIntensidad"))
	slider(g3, "Focus Distance", 0, 200, 1, G("lejosFoco"))
	slider(g3, "Focus Radius", 0, 200, 1, G("lejosRadio"))
	slider(g3, "Near Blur", 0, 1, 0.01, G("cercaIntensidad"))
	local g4 = grupo(pg, "Vignette", 2)
	interruptor(g4, "Enabled", G("vineta", actualizarVineta))
	slider(g4, "Strength", 0, 1, 0.01, G("vinetaFuerza", actualizarVineta))
	local g5 = grupo(pg, "Lens Flare", 2)
	interruptor(g5, "Sun Flare", G("destelloSol", extras.actualizar))
	slider(g5, "Strength", 0, 2, 0.05, G("destelloFuerza", extras.actualizar))
	interruptor(g5, "Realistic Sun", G("solRealista", extras.actualizar))
	slider(g5, "Sun Glow", 0, 2, 0.05, G("solBrillo", extras.actualizar))
	slider(g5, "Sun Size", 0.5, 2, 0.05, G("solTamano", extras.actualizar))
end

do
	local pg = crearPagina("Floors & Glass")
	local g1 = grupo(pg, "Floors", 1)
	interruptor(g1, "Shiny Floors", G("pisosBrillantes", actualizarSuperficies))
	slider(g1, "Brightness", 0, 1, 0.01, G("pisoReflectance", actualizarSuperficies))
	interruptor(g1, "Wet", G("pisoMojado", actualizarSuperficies))
	slider(g1, "Wet Shine", 0, 1, 0.01, G("mojadoReflectance", actualizarSuperficies))
	slider(g1, "Darken", 0, 0.6, 0.01, G("mojadoOscurecer", actualizarSuperficies))
	slider(g1, "Mirror Sharpness", 0, 1, 0.01, G("reflejoNitidez", actualizarSuperficies))
	local g2 = grupo(pg, "Glass", 2)
	interruptor(g2, "Glass Floor", G("pisoVidrio", actualizarSuperficies))
	slider(g2, "Transparency", 0, 1, 0.01, G("vidrioTransparencia", actualizarSuperficies))
	slider(g2, "Reflection", 0, 1, 0.01, G("vidrioReflectance", actualizarSuperficies))
	colores(g2, "Tone", { Color3.fromRGB(215, 235, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 255, 235), Color3.fromRGB(255, 220, 235), Color3.fromRGB(40, 40, 50) }, G("vidrioColor", actualizarSuperficies))
	local g3 = grupo(pg, "Walls & Textures", 1)
	interruptor(g3, "Shiny Walls", G("superficiesBrillantes", actualizarSuperficies))
	slider(g3, "Wall Shine", 0, 1, 0.01, G("paredReflectance", actualizarSuperficies))
	interruptor(g3, "Gloss Coat", G("barniz", actualizarSuperficies))
	slider(g3, "Gloss Strength", 0, 1, 0.01, G("barnizFuerza", actualizarSuperficies))
	slider(g3, "Wet Gloss", 0, 1, 0.01, G("mojadoBarniz", actualizarSuperficies))
	local g4 = grupo(pg, "Water", 2)
	interruptor(g4, "Reflective Water", G("aguaReflejo", actualizarAgua))
end

do
	local pg = crearPagina("Reflection")
	local g1 = grupo(pg, "Player Reflection", 1)
	interruptor(g1, "On", R("activado"))
	slider(g1, "Opacity", 0, 1, 0.01, R("reflejoOpacidad"))
	slider(g1, "Smear", 0, 2, 0.01, R("reflejoArrastre"))
	slider(g1, "Blur", 0, 3, 0.01, R("reflejoDesenfoque"))
	local g2 = grupo(pg, "Shape", 2)
	slider(g2, "Falloff", 0.5, 1, 0.01, R("reflejoCaida"))
	do
		local leer, escribir = R("desvanecerProfundidad")
		slider(g2, "Depth", 2, 20, 0.5, leer, escribir, 1)
	end
	colores(g2, "Tone", { Color3.fromRGB(150, 120, 95), Color3.fromRGB(235, 238, 250), Color3.fromRGB(120, 140, 200), Color3.fromRGB(90, 90, 100), Color3.fromRGB(200, 150, 220) }, R("reflejoTinte"))
	local g3 = grupo(pg, "World Reflection", 1)
	interruptor(g3, "On", R("escenario"))
	slider(g3, "Blur", 0, 1.5, 0.05, R("escenaBorroso"))
	slider(g3, "Opacity", 0, 1, 0.01, R("escenaOpacidad"))
	do
		local leer, escribir = R("escenaRadio")
		slider(g3, "Radius", 20, 120, 1, leer, escribir, 0)
	end
	nota(g3, "Mirrors the nearby world on shiny floors so the reflection moves as you walk.")
end

do
	local pg = crearPagina("Particles")
	local g1 = grupo(pg, "Dust", 1)
	interruptor(g1, "On", G("polvo", actualizarParticulas))
	slider(g1, "Fine Dust", 0, 300, 1, G("polvoCantidad", actualizarParticulas))
	slider(g1, "Sparkles", 0, 100, 1, G("destellosCantidad", actualizarParticulas))
	slider(g1, "Sand", 0, 40, 1, G("arenaCantidad", actualizarParticulas))
	local g2 = grupo(pg, "Color", 2)
	colores(g2, "Dust", { Color3.fromRGB(255, 236, 205), Color3.fromRGB(255, 255, 255), Color3.fromRGB(200, 220, 255), Color3.fromRGB(255, 200, 230), Color3.fromRGB(190, 255, 210) }, G("polvoColor", actualizarParticulas))
	local function ex() actualizarParticulas(); extras.actualizar() end
	local g3 = grupo(pg, "Nature", 1)
	slider(g3, "Breeze", 0, 1.5, 0.05, G("brisa", ex))
	interruptor(g3, "Dust Devils", G("remolinos", ex))
	slider(g3, "Fireflies", 0, 80, 1, G("luciernagas", ex))
	slider(g3, "Low Mist", 0, 12, 0.5, G("nieblaBaja", ex))
	colores(g3, "Mist Color", { Color3.fromRGB(200, 205, 215), Color3.fromRGB(150, 165, 200), Color3.fromRGB(255, 205, 175), Color3.fromRGB(170, 200, 210), Color3.fromRGB(235, 235, 235) }, G("nieblaBajaColor", ex))
end

do
	local pg = crearPagina("Skyboxes")
	local g1 = grupo(pg, "Skybox", 1)
	local gMas = grupo(pg, "More Skies", 2)
	local opciones = { "" }
	for _, c in ipairs(SKYBOXES.lista) do table.insert(opciones, c[1]) end
	local mitad = math.ceil(#opciones / 2)
	for i, nombre in ipairs(opciones) do
		local etiquetaSky = nombre == "" and "Map Sky" or nombre
		local b
		b = boton(i <= mitad and g1 or gMas, etiquetaSky, function()
			gfx.skybox = nombre
			SKYBOXES.avance = 0
			aplicarGraficos()
			extras.actualizar()
			refrescarTodo()
		end)
		textos[b] = nil
		local function pintar() b.Text = (gfx.skybox == nombre and "●  " or "") .. tr(etiquetaSky) end
		pintar()
		table.insert(refrescos, pintar)
	end
	nota(g1, "Your sky stays when you change presets.")
	local g2 = grupo(pg, "Sky Options", 2)
	interruptor(g2, "Sky Lighting", G("skyLuz"))
	interruptor(g2, "Sun Follows Sky", G("skySolAlinear", function() aplicarGraficos(); extras.actualizar() end))
	slider(g2, "Lighting Strength", 0, 1, 0.05, G("skyLuzFuerza"))
	slider(g2, "Sky Rotation", 0, 360, 1, G("skyGiro"))
	slider(g2, "Cloud Drift", 0, 3, 0.05, G("skyVelocidad"))
	nota(g2, "Cloud Drift slowly turns the sky so the clouds move.")
end

do
	local pg = crearPagina("Weather")
	local g1 = grupo(pg, "Rain", 1)
	interruptor(g1, "Make It Rain", G("lluvia", actualizarLluvia))
	slider(g1, "Intensity", 0, 6000, 50, G("lluviaIntensidad", actualizarLluvia))
	slider(g1, "Splashes", 0, 500, 5, G("lluviaSalpicaduras"))
	slider(g1, "Wind", -40, 40, 1, G("lluviaViento", actualizarLluvia))
	slider(g1, "Speed", 40, 200, 1, G("lluviaVelocidad", actualizarLluvia))
	slider(g1, "Drop Length", -3, 3, 0.1, G("lluviaEstirar", actualizarLluvia))
	slider(g1, "Overcast", 0, 1, 0.01, G("lluviaOscurecer", actualizarLluvia))
	interruptor(g1, "Lightning", G("relampagos"))
	slider(g1, "Near Drops", 0, 3000, 50, G("lluviaCerca"))
	interruptor(g1, "Lens Drops", G("lluviaLente"))
	slider(g1, "Ground Mist", 0, 25, 1, G("lluviaNeblinaSuelo"))

	local g3 = grupo(pg, "Thunderstorm", 1)
	interruptor(g3, "Storm", G("tormenta", actualizarLluvia))
	slider(g3, "Bolt Every (min)", 1, 30, 1, G("tormentaRayosMin"))
	slider(g3, "Bolt Every (max)", 2, 60, 1, G("tormentaRayosMax"))
	slider(g3, "Ground Strikes", 0, 1, 0.05, G("tormentaATierra"))
	slider(g3, "Gusts", 0, 1.5, 0.05, G("tormentaRafagas"))
	slider(g3, "Rain Curtains", 0, 20, 1, G("tormentaCortinas"))
	slider(g3, "Leaves & Debris", 0, 60, 1, G("tormentaEscombros"))
	interruptor(g3, "Windy Grass", G("pastoViento"))
	slider(g3, "Grass Strength", 0, 2, 0.05, G("pastoFuerza"))
	interruptor(g3, "Thunder Shake", G("tormentaTemblor"))
	boton(g3, "Strike Lightning Now", function()
		if gfx.lluvia and gfx.tormenta then task.spawn(rayo) end
	end)

	local g2 = grupo(pg, "Night", 2)
	interruptor(g2, "Night Mode", G("noche", function() actualizarNoche(); aurora.actualizar() end))
	slider(g2, "Time", 0, 5, 0.1, G("nocheHora", actualizarNoche))
	slider(g2, "Moonlight", 0, 3, 0.05, G("nocheLuna", actualizarNoche))
	slider(g2, "Exposure", -1, 1.5, 0.05, G("nocheExposicion", actualizarNoche))
	slider(g2, "Stars", 0, 8000, 50, G("nocheEstrellas", actualizarNoche))
	colores(g2, "Tone", { Color3.fromRGB(205, 218, 255), Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 200, 255), Color3.fromRGB(215, 205, 255), Color3.fromRGB(200, 240, 255) }, G("nocheTinte", actualizarNoche))
	interruptor(g2, "Flashlight", G("linterna", actualizarNoche))
	interruptor(g2, "Player Light", G("luzJugador", actualizarNoche))

	local function auroraYa() aurora.actualizar(); aplicarGraficos() end
	local g5 = grupo(pg, "Aurora", 2)
	interruptor(g5, "Northern Lights", G("aurora", auroraYa))
	slider(g5, "Intensity", 0, 2, 0.05, G("auroraIntensidad", auroraYa))
	slider(g5, "Speed", 0.2, 3, 0.05, G("auroraVelocidad", auroraYa))
	slider(g5, "Red Tops", 0, 1, 0.05, G("auroraRojo", auroraYa))
	interruptor(g5, "Substorms", G("auroraSubtormentas", auroraYa))
	interruptor(g5, "Shooting Stars", G("auroraFugaces", auroraYa))
	interruptor(g5, "Diamond Dust", G("auroraEscarcha", auroraYa))
	interruptor(g5, "Soft Bands", G("auroraBandas", auroraYa))
	slider(g5, "Curtain Rays", 0, 1.5, 0.05, G("auroraRayos", auroraYa))
	boton(g5, "Trigger Substorm", function() aurora.subtormenta() end)
	nota(g5, "Needs Night Mode on.")
end

local ACENTOS = {
	Color3.fromRGB(235, 235, 240), Color3.fromRGB(120, 170, 255), Color3.fromRGB(170, 125, 255),
	Color3.fromRGB(255, 110, 150), Color3.fromRGB(110, 225, 165), Color3.fromRGB(255, 185, 90),
}

local fpsPantalla = etiqueta({
	Text = "", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.texto,
	TextStrokeTransparency = 0.6, Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(120, 18),
	Visible = false, Parent = panelGui,
})
do
	local cuadros, acum = 0, 0
	RunService.RenderStepped:Connect(function(dt)
		cuadros += 1
		acum += dt
		if acum >= 0.5 then
			local t = string.format("FPS: %d", math.floor(cuadros / acum + 0.5))
			fpsEtiqueta.Text = t
			fpsPantalla.Text = t
			cuadros, acum = 0, 0
		end
	end)
end

-- movimiento suave del scroll (rueda del mouse)
RunService.RenderStepped:Connect(function(dt)
	if not ventana.Visible then return end
	local p = paginas[paginaActual]
	if not (p and p.suave) then return end
	local sv = p.suave
	local falta = sv.objetivo - sv.mostrado
	if math.abs(falta) < 0.4 then
		if sv.mostrado ~= sv.objetivo then sv.mostrado = sv.objetivo else return end
	else
		sv.mostrado += falta * (1 - math.exp(-dt * 11 * math.max(ui.velocidadAnim, 0.3)))
	end
	sv.ultimo = math.floor(sv.mostrado + 0.5)
	p.scroll.CanvasPosition = Vector2.new(0, sv.ultimo)
end)

local refrescarPuntero
do
	local pg = nuevo("ScreenGui", { Name = "Phant0nPuntero", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 200 })
	local punto = nuevo("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(8, 8), Visible = false, Parent = pg }, {
		redonda(), nuevo("UIStroke", { Thickness = 1.5, Color = Color3.new(0, 0, 0), Transparency = 0.45 }),
	})
	acento(punto, "BackgroundColor3")
	local activo, iconoAntes, antes = false, true, nil

	local function mostrar()
		if activo or not (ui.puntero and UserInputService.MouseEnabled) then return end
		activo, antes = true, nil
		iconoAntes = UserInputService.MouseIconEnabled
		punto.Size = UDim2.fromOffset(0, 0)
		punto.Visible = true
		tween(punto, 0.35, { Size = UDim2.fromOffset(8, 8) }, Enum.EasingStyle.Back)
	end
	local function ocultar()
		if not activo then return end
		activo = false
		punto.Visible = false
		UserInputService.MouseIconEnabled = iconoAntes
	end
	refrescarPuntero = function()
		if ventana.Visible and ui.puntero then mostrar() else ocultar() end
	end
	table.insert(alAbrir, mostrar)
	table.insert(alCerrar, ocultar)

	-- con el panel abierto el mouse queda libre aunque el juego lo tenga bloqueado
	local liberador = nuevo("TextButton", { Name = "MouseLibre", Text = "", BackgroundTransparency = 1, Size = UDim2.fromOffset(0, 0), Modal = true, Visible = false, Parent = panelGui })
	local antesMouse, antesIcono
	table.insert(alAbrir, function()
		antesMouse = UserInputService.MouseBehavior
		antesIcono = UserInputService.MouseIconEnabled
		liberador.Visible = true
		RunService:BindToRenderStep("GFX_MouseLibre", Enum.RenderPriority.Last.Value + 100, function()
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
			if not activo then UserInputService.MouseIconEnabled = true end
		end)
	end)
	table.insert(alCerrar, function()
		liberador.Visible = false
		pcall(function() RunService:UnbindFromRenderStep("GFX_MouseLibre") end)
		if antesMouse then UserInputService.MouseBehavior = antesMouse end
		if not activo and antesIcono ~= nil then UserInputService.MouseIconEnabled = antesIcono end
	end)

	UserInputService.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then cursorEstado.presionado = true end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then cursorEstado.presionado = false end
	end)

	RunService.RenderStepped:Connect(function()
		if not activo then return end
		UserInputService.MouseIconEnabled = false
		local m = UserInputService:GetMouseLocation()
		punto.Position = UDim2.fromOffset(m.X, m.Y)
		local estado = cursorEstado.presionado and 1 or ((cursorEstado.encima and cursorEstado.encima.Visible) and 2 or 0)
		if estado ~= antes then
			antes = estado
			local tam = estado == 1 and 6 or (estado == 2 and 12 or 8)
			tween(punto, 0.25, { Size = UDim2.fromOffset(tam, tam), BackgroundTransparency = estado == 2 and 0.15 or 0 }, Enum.EasingStyle.Back)
		end
	end)
	pg.Parent = player:WaitForChild("PlayerGui")
end

local function aplicarUI()
	for _, a in ipairs(conAcento) do if a[1].Parent then a[1][a[2]] = ui.acento end end
	for _, f in ipairs(conFondo) do f[1].BackgroundTransparency = math.clamp(f[2] + ui.transparencia, 0, 1) end
	for _, e in ipairs(conEsquina) do e[1].CornerRadius = UDim.new(0, e[2] * ui.esquinas) end
	local fuente = FUENTES[ui.fuente] or FUENTES[1]
	for _, t in ipairs(conTexto) do
		if t[1].Parent then t[1].Font = t[2] and fuente[3] or fuente[2] end
	end
	if not ventana.Visible then escala.Scale = ui.escala else escala.Scale = ui.escala end
	fpsPantalla.Visible = ui.mostrarFps
	blurFondo.Size = (ventana.Visible and ui.desenfocarFondo) and 10 or 0
	for inst, t in pairs(textos) do
		local txt = tr(t[1])
		inst.Text = t[2] and string.upper(txt) or txt
	end
	buscador.PlaceholderText = tr("Search settings...")
	pintarMarca()
	pintarTecla()
	if paginaActual then mostrarPagina(paginaActual) end
	refrescarPuntero()
	refrescarTodo()
end

local function U(campo)
	return function() return ui[campo] end, function(v) ui[campo] = v; aplicarUI() end
end

do
	local pg = crearPagina("Settings")

	local g = grupo(pg, "Appearance", 1)
	colores(g, "Accent Color", ACENTOS, U("acento"))
	do
		local nombres = {}
		for i, f in ipairs(FUENTES) do nombres[i] = f[1] end
		selector(g, "Font", nombres, U("fuente"))
	end
	slider(g, "Roundness", 0, 2, 0.1, U("esquinas"))

	g = grupo(pg, "Animations", 2)
	interruptor(g, "Animations", U("animaciones"))
	slider(g, "Speed", 0.5, 2, 0.05, U("velocidadAnim"))
	slider(g, "Scroll Step", 0.5, 3, 0.1, U("pasoRueda"))
	interruptor(g, "Intro Animation", U("entrada"))

	g = grupo(pg, "Window", 1)
	slider(g, "Transparency", 0, 0.6, 0.01, U("transparencia"))
	slider(g, "Size", 0.6, 1.4, 0.05, U("escala"))
	interruptor(g, "Blur Background", U("desenfocarFondo"))
	interruptor(g, "Custom Cursor", U("puntero"))
	boton(g, "Center Window", function() tween(ventana, 0.5, { Position = UDim2.fromScale(0.5, 0.5) }) end)

	g = grupo(pg, "Language", 2)
	selector(g, "Language", { "English", "Español", "Português (BR)", "Русский" }, U("idioma"))

	g = grupo(pg, "Controls", 1)
	local esperando = false
	local bTecla
	local function textoTecla() return tr("Change Key") .. " (" .. ui.tecla.Name .. ")" end
	local function textoShader() return tr("Shader Key") .. " (" .. ui.teclaShader.Name .. ")" end
	local bShader
	bTecla = boton(g, "Change Key", function()
		esperando = "panel"
		bTecla.Text = tr("Press a key...")
	end)
	bShader = boton(g, "Shader Key", function()
		esperando = "shader"
		bShader.Text = tr("Press a key...")
	end)
	textos[bTecla], textos[bShader] = nil, nil
	bTecla.Text, bShader.Text = textoTecla(), textoShader()
	table.insert(refrescos, function()
		if not esperando then bTecla.Text, bShader.Text = textoTecla(), textoShader() end
	end)

	local aviso = etiqueta({
		Text = "", Font = Enum.Font.GothamBold, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Center,
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 18), Size = UDim2.fromOffset(220, 32),
		BackgroundColor3 = C.fondo, TextTransparency = 1, Visible = false, Parent = panelGui,
	})
	aviso.BackgroundTransparency = 1
	esquina(8).Parent = aviso
	local avisoN = 0
	local function avisar(texto)
		avisoN += 1
		local n = avisoN
		aviso.Text = texto
		aviso.Visible = true
		aviso.Position = UDim2.new(0.5, 0, 0, 8)
		tween(aviso, 0.35, { TextTransparency = 0, BackgroundTransparency = 0.15, Position = UDim2.new(0.5, 0, 0, 18) })
		task.delay(1.4, function()
			if n ~= avisoN then return end
			local t = tween(aviso, 0.35, { TextTransparency = 1, BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
			t.Completed:Once(function() if n == avisoN then aviso.Visible = false end end)
		end)
	end
	UserInputService.InputBegan:Connect(function(i, procesado)
		if esperando and i.UserInputType == Enum.UserInputType.Keyboard then
			if i.KeyCode ~= Enum.KeyCode.Escape then
				if esperando == "panel" then ui.tecla = i.KeyCode else ui.teclaShader = i.KeyCode end
			end
			esperando = false
			bTecla.Text, bShader.Text = textoTecla(), textoShader()
			pintarTecla()
			return
		end
		if UserInputService:GetFocusedTextBox() then return end
		if i.KeyCode == ui.tecla then
			alternarPanel()
		elseif i.KeyCode == ui.teclaShader and i.KeyCode ~= Enum.KeyCode.Unknown then
			local encendido = alternarShader()
			refrescarTodo()
			avisar(tr(encendido and "Shader ON" or "Shader OFF"))
		end
	end)
	interruptor(g, "Open on Join", U("abrirAlEntrar"))
	interruptor(g, "Show FPS", U("mostrarFps"))

	g = grupo(pg, "Reset", 2)
	boton(g, "Reset GUI", function()
		for k, v in pairs(ORIGINAL_UI) do ui[k] = v end
		aplicarUI()
	end)
	nota(g, "Settings stay while you're in the server.")
end

buscador:GetPropertyChangedSignal("Text"):Connect(function()
	local q = string.lower(buscador.Text)
	for _, fl in ipairs(filas) do
		if paginas[paginaActual] == fl[3] then
			fl[1].Visible = (q == "") or (string.find(string.lower(tr(fl[2])), q, 1, true) ~= nil)
				or (string.find(string.lower(fl[2]), q, 1, true) ~= nil)
		end
	end
end)

mostrarPagina("Home")
aplicarUI()
panelGui.Parent = player:WaitForChild("PlayerGui")

local function reproducirEntrada(alTerminar)
	local eg = nuevo("ScreenGui", { Name = "Phant0nEntrada", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 100 })
	local velo = nuevo("Frame", { BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = eg })
	local centro = nuevo("Frame", { BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(420, 150), Parent = velo })
	local r, g, b = math.floor(ui.acento.R * 255), math.floor(ui.acento.G * 255), math.floor(ui.acento.B * 255)
	local titulo = etiqueta({
		RichText = true, Text = string.format('%s <font color="rgb(%d,%d,%d)">%s</font>', ui.titulo, r, g, b, ui.subtitulo),
		Font = Enum.Font.GothamBold, TextSize = 38, TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Center,
		Position = UDim2.fromOffset(0, 45), Size = UDim2.new(1, 0, 0, 50), Parent = centro,
	})
	local linea = nuevo("Frame", { BackgroundColor3 = ui.acento, BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 84), Size = UDim2.fromOffset(0, 1), Parent = centro })
	local estado = etiqueta({ Text = "", TextSize = 12, TextColor3 = C.sub, TextTransparency = 1, TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(0, 94), Size = UDim2.new(1, 0, 0, 16), Parent = centro })
	local barra = nuevo("Frame", { BackgroundColor3 = C.pista, BorderSizePixel = 0, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 120), Size = UDim2.fromOffset(220, 3), Parent = centro }, { esquina(2) })
	local relleno = nuevo("Frame", { BackgroundColor3 = ui.acento, BorderSizePixel = 0, Size = UDim2.fromScale(0, 1), Parent = barra }, { esquina(2) })
	eg.Parent = player:WaitForChild("PlayerGui")

	local function tw(obj, t, props) local x = TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props); x:Play(); return x end
	tw(velo, 0.4, { BackgroundTransparency = 0.2 })
	tw(titulo, 0.7, { TextTransparency = 0, Position = UDim2.fromOffset(0, 30) })
	task.wait(0.35)
	tw(linea, 0.6, { Size = UDim2.fromOffset(200, 1) })
	tw(estado, 0.4, { TextTransparency = 0 })
	tw(barra, 0.3, { BackgroundTransparency = 0 })
	for i, m in ipairs({ "loading lights", "preparing floors", "tuning colors", "ready" }) do
		estado.Text = tr(m)
		tw(relleno, 0.4, { Size = UDim2.fromScale(i / 4, 1) })
		task.wait(0.42)
	end
	task.wait(0.2)
	tw(titulo, 0.35, { TextTransparency = 1, Position = UDim2.fromOffset(0, 20) })
	tw(estado, 0.3, { TextTransparency = 1 })
	tw(barra, 0.3, { BackgroundTransparency = 1 })
	tw(relleno, 0.3, { BackgroundTransparency = 1 })
	tw(linea, 0.3, { BackgroundTransparency = 1 })
	local fin = tw(velo, 0.45, { BackgroundTransparency = 1 })
	task.wait(0.15)
	if alTerminar then alTerminar() end
	fin.Completed:Wait()
	eg:Destroy()
end

-- aviso al entrar: recomendar buena calidad de gráficos
function PRESETS.recomendar()
	local cartel = nuevo("Frame", {
		AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -60), Size = UDim2.fromOffset(0, 40),
		AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = C.fondo, BackgroundTransparency = 0.1, Parent = panelGui,
	}, { esquina(10), borde(C.bordeClaro), nuevo("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) }) })
	local barra = nuevo("Frame", { BorderSizePixel = 0, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -8, 0.5, 0), Size = UDim2.fromOffset(3, 18) }, { redonda() })
	acento(barra, "BackgroundColor3")
	barra.Parent = cartel
	local texto = etiqueta({
		Text = tr("High graphics quality is recommended"), Font = Enum.Font.GothamBold, TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 40), Parent = cartel,
	})
	textos[texto] = nil
	tween(cartel, 0.6, { Position = UDim2.new(0.5, 0, 0, 22) }, Enum.EasingStyle.Back)
	task.delay(6, function()
		local t = tween(cartel, 0.45, { Position = UDim2.new(0.5, 0, 0, -60) }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
		t.Completed:Wait()
		cartel:Destroy()
	end)
end

-- al entrar no se aplica nada: ni shader ni cielo hasta que elijas uno en el panel
alternarShader()
refrescarTodo()
task.spawn(function()
	local function despues()
		PRESETS.recomendar()
		if ui.abrirAlEntrar then abrirPanel() end
	end
	if ui.entrada then
		reproducirEntrada(despues)
	else
		despues()
	end
end)

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	blurFondo.Parent = workspace.CurrentCamera
end)