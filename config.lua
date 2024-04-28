FEZCO = {}

-- LEAKED BY FEZCO (DISCORD: fezcosmokes)

FEZCO.Bank = "bank"

FEZCO.Webhook = ''

FEZCO.Enabledrugsverwerk = true

-- LEAKED BY FEZCO (DISCORD: fezcosmokes)

FEZCO.Drugslabs = { 
    ["#1 XTC Loods"] = { -- DEZE NAMEN MOGEN NIET HETZELRDE ZIJN!!!! 
        Marker = vector3(-665.2797, 165.1616, 59.34878), -- waar je voertuigen kunt zien
        Markervehicle = vector3(-875.32, -215.54, -38.25),
        Tpinside = {x = 1088.66, y = -3187.92, z= -38.99, h = 178.45}, -- binnen in de loods waar je heen tpd
        type = "XTC",
        databaseitem = "xtc",
        prijs = 500000,
        buylimit = 1,
        verkoopprice = 2.3, -- de prijs / dit cijfer (dus 2 miljoen/2.3)
        maxtobuy = 1, -- max aantal loodsen die de hele server kan kopenm
        maxsecondusers = 2, -- max aantal second users die kunnen worden toegevoegd
        insertserversided = "xtcloods1", -- niet aankomen!!!  verander deze bij elke loods die je toevoegd naar tweede, derde, vierde, vijfde etc etc
        [1] = {
            insidedrugssafe = vector3(1101.6512, -3194.0608, -38.9935), -- marker van waar je je items kan verwerken etc 
            limititems = 250,
            insideloodstpnaarbuiten = {x = 1088.71, y = -3188.35, z= -38.99}, -- marker van de tp naar buiten
            insidemanagementmarker = {x = 1087.74, y = -3194.13, z= -38.99}, -- marker van het boss menu (alleen hoofd van de loods kan dit zien)
            databaseverwerkitem = "xtc_leaf",
            [2] = {
                {string = "Upgrade 0", price = 0, value = 0, itemlimiet = 150, verwerkingitems = 0, weaponuse = false}, -- zo laten
                {string = "Upgrade 1", price = 120000, value = 1, itemlimiet = 200, verwerkingitems = 1, weaponuse = true},
                {string = "Upgrade 2", price = 140000, value = 2, itemlimiet = 250, verwerkingitems = 2, weaponuse = true},
                {string = "Upgrade 3", price = 160000, value = 3, itemlimiet = 300, verwerkingitems = 3, weaponuse = true},
                {string = "Upgrade 4", price = 180000, value = 4, itemlimiet = 350, verwerkingitems = 4, weaponuse = true}
            },
        },
    },
    ["#1 Coke Loods"] = { -- DEZE NAMEN MOGEN NIET HETZELRDE ZIJN!!!! 
        Marker = vector3(-550.1119, -1795.087, 22.3767), -- waar je voertuigen kunt zien
        Markervehicle = vector3(-875.32, -215.54, -38.25),
        Tpinside = {x = 1088.66, y = -3187.92, z= -38.99, h = 178.45}, -- binnen in de loods waar je heen tpd
        type = "Coke",
        databaseitem = "coke",
        prijs = 2000000,
        buylimit = 1,
        verkoopprice = 2.3, -- de prijs / dit cijfer (dus 2 miljoen/2.3)
        maxtobuy = 1, -- max aantal loodsen die de hele server kan kopenm
        maxsecondusers = 2, -- max aantal second users die kunnen worden toegevoegd
        insertserversided = "cokeloods1", -- niet aankomen!!!  verander deze bij elke loods die je toevoegd naar tweede, derde, vierde, vijfde etc etc
        [1] = {
            insidedrugssafe = vector3(1101.6512, -3194.0608, -38.9935), -- marker van waar je je items kan verwerken etc 
            limititems = 400,
            insideloodstpnaarbuiten = {x = 1088.71, y = -3188.35, z= -38.99}, -- marker van de tp naar buiten
            insidemanagementmarker = {x = 1087.74, y = -3194.13, z= -38.99}, -- marker van het boss menu (alleen hoofd van de loods kan dit zien)
            databaseverwerkitem = "cocaleaf",
            [2] = {
                {string = "Upgrade 0", price = 0, value = 0, itemlimiet = 150, verwerkingitems = 0, weaponuse = false}, -- zo laten
                {string = "Upgrade 1", price = 120000, value = 1, itemlimiet = 200, verwerkingitems = 1, weaponuse = true},
                {string = "Upgrade 2", price = 140000, value = 2, itemlimiet = 250, verwerkingitems = 2, weaponuse = true},
                {string = "Upgrade 3", price = 160000, value = 3, itemlimiet = 300, verwerkingitems = 3, weaponuse = true}, -- LEAKED BY FEZCO (DISCORD: fezcosmokes)
                {string = "Upgrade 4", price = 180000, value = 4, itemlimiet = 350, verwerkingitems = 4, weaponuse = true}
            },
        },
    },
    ["#2 Coke Loods"] = { -- DEZE NAMEN MOGEN NIET HETZELRDE ZIJN!!!! 
        Marker = vector3(-1500.3625, -892.6685, 10.1075), -- waar je voertuigen kunt zien
        Markervehicle = vector3(-875.32, -215.54, -38.25),
        Tpinside = {x = 1088.66, y = -3187.92, z= -38.99, h = 178.45}, -- binnen in de loods waar je heen tpd
        type = "Coke",
        databaseitem = "coke",
        prijs = 2000000,
        buylimit = 1,
        verkoopprice = 2.3, -- de prijs / dit cijfer (dus 2 miljoen/2.3)
        maxtobuy = 1, -- max aantal loodsen die de hele server kan kopenm
        maxsecondusers = 2, -- max aantal second users die kunnen worden toegevoegd
        insertserversided = "cokeloods2", -- niet aankomen!!!  verander deze bij elke loods die je toevoegd naar tweede, derde, vierde, vijfde etc etc
        [1] = {
            insidedrugssafe = vector3(1101.6512, -3194.0608, -38.9935), -- marker van waar je je items kan verwerken etc 
            limititems = 400,
            insideloodstpnaarbuiten = {x = 1088.71, y = -3188.35, z= -38.99}, -- marker van de tp naar buiten
            insidemanagementmarker = {x = 1087.74, y = -3194.13, z= -38.99}, -- marker van het boss menu (alleen hoofd van de loods kan dit zien)
            databaseverwerkitem = "cocaleaf",
            [2] = {
                {string = "Upgrade 0", price = 0, value = 0, itemlimiet = 150, verwerkingitems = 0, weaponuse = false}, -- zo laten
                {string = "Upgrade 1", price = 120000, value = 1, itemlimiet = 200, verwerkingitems = 1, weaponuse = true},
                {string = "Upgrade 2", price = 140000, value = 2, itemlimiet = 250, verwerkingitems = 2, weaponuse = true},
                {string = "Upgrade 3", price = 160000, value = 3, itemlimiet = 300, verwerkingitems = 3, weaponuse = true},
                {string = "Upgrade 4", price = 180000, value = 4, itemlimiet = 350, verwerkingitems = 4, weaponuse = true} -- LEAKED BY FEZCO (DISCORD: fezcosmokes)
            },
        },
    },
    ["#3 Coke Loods"] = { -- DEZE NAMEN MOGEN NIET HETZELRDE ZIJN!!!! 
        Marker = vector3(-297.2105, 303.7697, 90.7183), -- waar je voertuigen kunt zien
        Markervehicle = vector3(-875.32, -215.54, -38.25),
        Tpinside = {x = 1088.66, y = -3187.92, z= -38.99, h = 178.45}, -- binnen in de loods waar je heen tpd
        type = "Coke",
        databaseitem = "coke",
        prijs = 2000000,
        buylimit = 1,
        verkoopprice = 2.3, -- de prijs / dit cijfer (dus 2 miljoen/2.3)
        maxtobuy = 1, -- max aantal loodsen die de hele server kan kopenm
        maxsecondusers = 2, -- max aantal second users die kunnen worden toegevoegd
        insertserversided = "cokeloods3", -- niet aankomen!!!  verander deze bij elke loods die je toevoegd naar tweede, derde, vierde, vijfde etc etc
        [1] = {
            insidedrugssafe = vector3(1101.6512, -3194.0608, -38.9935), -- marker van waar je je items kan verwerken etc 
            limititems = 400,
            insideloodstpnaarbuiten = {x = 1088.71, y = -3188.35, z= -38.99}, -- marker van de tp naar buiten
            insidemanagementmarker = {x = 1087.74, y = -3194.13, z= -38.99}, -- marker van het boss menu (alleen hoofd van de loods kan dit zien)
            databaseverwerkitem = "cocaleaf",
            [2] = {
                {string = "Upgrade 0", price = 0, value = 0, itemlimiet = 150, verwerkingitems = 0, weaponuse = false}, -- zo laten
                {string = "Upgrade 1", price = 120000, value = 1, itemlimiet = 200, verwerkingitems = 1, weaponuse = true},
                {string = "Upgrade 2", price = 140000, value = 2, itemlimiet = 250, verwerkingitems = 2, weaponuse = true},
                {string = "Upgrade 3", price = 160000, value = 3, itemlimiet = 300, verwerkingitems = 3, weaponuse = true},
                {string = "Upgrade 4", price = 180000, value = 4, itemlimiet = 350, verwerkingitems = 4, weaponuse = true} -- LEAKED BY FEZCO (DISCORD: fezcosmokes)
            },
        },
    },
    ["#4 Coke Loods"] = { -- DEZE NAMEN MOGEN NIET HETZELRDE ZIJN!!!! 
        Marker = vector3(-2022.392, -255.4308, 23.4205), -- waar je voertuigen kunt zien
        Markervehicle = vector3(-875.32, -215.54, -38.25),
        Tpinside = {x = 1088.66, y = -3187.92, z= -38.99, h = 178.45}, -- binnen in de loods waar je heen tpd
        type = "Coke",
        databaseitem = "coke",
        prijs = 2000000,
        buylimit = 1,
        verkoopprice = 2.3, -- de prijs / dit cijfer (dus 2 miljoen/2.3)
        maxtobuy = 1, -- max aantal loodsen die de hele server kan kopenm
        maxsecondusers = 2, -- max aantal second users die kunnen worden toegevoegd
        insertserversided = "cokeloods4", -- niet aankomen!!!  verander deze bij elke loods die je toevoegd naar tweede, derde, vierde, vijfde etc etc
        [1] = {
            insidedrugssafe = vector3(1101.6512, -3194.0608, -38.9935), -- marker van waar je je items kan verwerken etc 
            limititems = 400,
            insideloodstpnaarbuiten = {x = 1088.71, y = -3188.35, z= -38.99}, -- marker van de tp naar buiten
            insidemanagementmarker = {x = 1087.74, y = -3194.13, z= -38.99}, -- marker van het boss menu (alleen hoofd van de loods kan dit zien)
            databaseverwerkitem = "cocaleaf",
            [2] = {
                {string = "Upgrade 0", price = 0, value = 0, itemlimiet = 150, verwerkingitems = 0, weaponuse = false}, -- zo laten
                {string = "Upgrade 1", price = 120000, value = 1, itemlimiet = 200, verwerkingitems = 1, weaponuse = true},
                {string = "Upgrade 2", price = 140000, value = 2, itemlimiet = 250, verwerkingitems = 2, weaponuse = true},
                {string = "Upgrade 3", price = 160000, value = 3, itemlimiet = 300, verwerkingitems = 3, weaponuse = true}, -- LEAKED BY FEZCO (DISCORD: fezcosmokes)
                {string = "Upgrade 4", price = 180000, value = 4, itemlimiet = 350, verwerkingitems = 4, weaponuse = true}
            },
        },
    }
}
-- LEAKED BY FEZCO (DISCORD: fezcosmokes)

FEZCO.Verwerkdrugstimes = {
    {verwerktijd = 5, verwerkteitems = 18},-- verwerktijd is elk uur welke miuut je wil dat er verwerkt word
    {verwerktijd = 10, verwerkteitems = 18},
    {verwerktijd = 15, verwerkteitems = 18},
    {verwerktijd = 20, verwerkteitems = 18},
    {verwerktijd = 25, verwerkteitems = 18},
    {verwerktijd = 30, verwerkteitems = 18},
    {verwerktijd = 35, verwerkteitems = 18},
    {verwerktijd = 40, verwerkteitems = 18},
    {verwerktijd = 45, verwerkteitems = 17},
    {verwerktijd = 50, verwerkteitems = 16},
    {verwerktijd = 55, verwerkteitems = 15},
    {verwerktijd = 60, verwerkteitems = 18},
}
-- LEAKED BY FEZCO (DISCORD: fezcosmokes)
FEZCO.CanRemoveingredienten = true -- kan iemand zijn onverwerkte items nog uit zijn loods halen?
-- LEAKED BY FEZCO (DISCORD: fezcosmokes)
FEZCO.DebugCommand = true
-- LEAKED BY FEZCO (DISCORD: fezcosmokes)