
function newResource(name, category, tier, mass, volume)
    return {
        name = name,
        key = makeResourceKey(name),
        category = category,
        tier = tier,
        mass = mass,
        volume = volume,
        massPerLiter = mass / volume,
    }
end

function makeResourceKey(name)
    return trimPrefix(
        trimSuffix(
            name:lower():gsub(" ", "_"):gsub("-", ""), 
            "_pure"), 
        "pure_")
end

local resources = {}
local resourceKeyCache = {}
function findResource(name)
    local findResourceKey = makeResourceKey(name)
    local knownResourceKey = resourceKeyCache[findResourceKey]
    if knownResourceKey ~= nil then
        return resources[knownResourceKey]
    end

    local tryKeys = {
        findResourceKey,
        trimSuffix(findResourceKey, "s")
    }

    for k, tryKey in ipairs(tryKeys) do
        if resources[tryKey] ~= nil then
            resourceKeyCache[findResourceKey] = tryKey

            return resources[tryKey]
        end
    end

    return nil
end

-- global
resources = {
    bauxite = newResource("Bauxite", "Ore", 1, 1.28, 1),
    coal = newResource("Coal", "Ore", 1, 1.35, 1),
    quartz = newResource("Quartz", "Ore", 1, 2.65, 1),
    hematite = newResource("Hematite", "Ore", 1, 5.04, 1),
    chromite = newResource("Chromite", "Ore", 2, 7.19, 1),
    malachite = newResource("Malachite", "Ore", 2, 4, 1),
    limestone = newResource("Limestone", "Ore", 2, 0.968, 1),
    natron = newResource("Natron", "Ore", 2, 1.55, 1),
    petalite = newResource("Petalite", "Ore", 3, 2.41, 1),
    garnierite = newResource("Garnierite", "Ore", 3, 2.6, 1),
    acanthite = newResource("Acanthite", "Ore", 3, 7.2, 1),
    pyrite = newResource("Pyrite", "Ore", 3, 5.01, 1),
    cobaltite = newResource("Cobaltite", "Ore", 4, 6.33, 1),
    cryolite = newResource("Cryolite", "Ore", 4, 2.95, 1),
    kolbeckite = newResource("Kolbeckite", "Ore", 4, 2.37, 1),
    gold_nuggets = newResource("Gold Nuggets", "Ore", 4, 19.3, 1),
    rhodonite = newResource("Rhodonite", "Ore", 5, 3.76, 1),
    columbite = newResource("Columbite", "Ore", 5, 5.38, 1),
    illmenite = newResource("Illmenite", "Ore", 5, 4.55, 1),
    vanadinite = newResource("Vanadinite", "Ore", 5, 6.95, 1),
    pure_oxygen = newResource("Oxygen Pure", "Pure", 1, 1, 1),
    pure_hydrogen = newResource("Hydrogen Pure", "Pure", 1, 0.07, 1),
    pure_aluminium = newResource("Aluminium Pure", "Pure", 1, 2.7, 1),
    pure_carbon = newResource("Carbon Pure", "Pure", 1, 2.27, 1),
    pure_silicon = newResource("Silicon Pure", "Pure", 1, 2.33, 1),
    pure_iron = newResource("Iron Pure", "Pure", 1, 7.85, 1),
    pure_calcium = newResource("Calcium Pure", "Pure", 2, 1.55, 1),
    pure_chromium = newResource("Chromium Pure", "Pure", 2, 7.19, 1),
    pure_copper = newResource("Copper Pure", "Pure", 2, 8.96, 1),
    pure_sodium = newResource("Sodium Pure", "Pure", 2, 0.97, 1),
    pure_lithium = newResource("Lithium Pure", "Pure", 3, 0.53, 1),
    pure_nickel = newResource("Nickel Pure", "Pure", 3, 8.91, 1),
    pure_silver = newResource("Silver Pure", "Pure", 3, 10.49, 1),
    pure_sulfur = newResource("Sulfur Pure", "Pure", 3, 1.82, 1),
    pure_cobalt = newResource("Cobalt Pure", "Pure", 4, 8.9, 1),
    pure_fluorine = newResource("Fluorine Pure", "Pure", 4, 1.7, 1),
    pure_gold = newResource("Gold Pure", "Pure", 4, 19.3, 1),
    pure_scandium = newResource("Scandium Pure", "Pure", 4, 2.98, 1),
    pure_manganese = newResource("Manganese Pure", "Pure", 5, 7.21, 1),
    pure_niobium = newResource("Niobium Pure", "Pure", 5, 8.57, 1),
    pure_titanium = newResource("Titanium Pure", "Pure", 5, 4.51, 1),
    pure_vanadium = newResource("Vanadium Pure", "Pure", 5, 6, 1),
    alfe_alloy = newResource("Al-Fe Alloy", "Product", 1, 7.5, 1),
    alli_alloy = newResource("Al-Li Alloy", "Product", 3, 2.5, 1),
    calcium_reinforced_copper = newResource("Calcium Reinforced Copper", "Product", 2, 8.1, 1),
    cuag_alloy = newResource("Cu-Ag Alloy", "Product", 3, 9.2, 1),
    duralumin = newResource("Duralumin", "Product", 2, 2.8, 1),
    grade_5_titanium_alloy = newResource("Grade 5 Titanium Alloy", "Product", 5, 4.43, 1),
    inconel = newResource("Inconel", "Product", 3, 8.5, 1),
    mangalloy = newResource("Mangalloy", "Product", 5, 7.83, 1),
    maraging_steel = newResource("Maraging Steel", "Product", 4, 8.23, 1),
    red_gold = newResource("Red Gold", "Product", 4, 14.13, 1),
    scal_alloy = newResource("Sc-Al Alloy", "Product", 4, 2.85, 1),
    stainless_steel = newResource("Stainless Steel", "Product", 2, 7.75, 1),
    tinb_supraconductor = newResource("Ti-Nb Supraconductor", "Product", 5, 10.1, 1),
    biological_matter = newResource("Biological Matter", "Product", 1, 1, 1),
    brick = newResource("Brick", "Product", 1, 1.92, 1),
    marble = newResource("Marble", "Product", 2, 2.7, 1),
    concrete = newResource("Concrete", "Product", 2, 2.41, 1),
    carbon_fiber = newResource("Carbon Fiber", "Product", 1, 1.5, 1),
    glass = newResource("Glass", "Product", 1, 2.5, 1),
    advanced_glass = newResource("Advanced Glass", "Product", 2, 2.6, 1),
    agli_reinforced_glass = newResource("Ag-Li Reinforced Glass", "Product", 3, 2.8, 1),
    gold_coated_glass = newResource("Gold Coated Glass", "Product", 4, 3, 1),
    manganese_reinforced_glass = newResource("Manganese Reinforced Glass", "Product", 5, 2.9, 1),
    polycarbonate_plastic = newResource("Polycarbonate Plastic", "Product", 1, 1.4, 1),
    polycalcite_plastic = newResource("Polycalcite Plastic", "Product", 2, 1.5, 1),
    polysulfide_plastic = newResource("Polysulfide Plastic", "Product", 3, 1.6, 1),
    fluoropolymer = newResource("Fluoropolymer", "Product", 4, 1.65, 1),
    vanamer = newResource("Vanamer", "Product", 5, 1.57, 1),
    silumin = newResource("Silumin", "Product", 1, 3, 1),
    steel = newResource("Steel", "Product", 1, 8.05, 1),
    wood = newResource("Wood", "Product", 1, 0.6, 1),
    basic_component = newResource("Basic Component", "Intermediary Part", 1, 2.25, 0.5),
    uncommon_component = newResource("Uncommon Component", "Intermediary Part", 2, 2.34, 0.8),
    advanced_component = newResource("Advanced Component", "Intermediary Part", 3, 2.51, 0.8),
    basic_connector = newResource("Basic Connector", "Intermediary Part", 1, 3.75, 0.8),
    uncommon_connector = newResource("Uncommon Connector", "Intermediary Part", 2, 3.9, 0.8),
    advanced_connector = newResource("Advanced Connector", "Intermediary Part", 3, 4.18, 0.8),
    basic_fixation = newResource("Basic Fixation", "Intermediary Part", 1, 1.12, 1),
    uncommon_fixation = newResource("Uncommon Fixation", "Intermediary Part", 2, 1.16, 1),
    advanced_fixation = newResource("Advanced Fixation", "Intermediary Part", 3, 1.21, 1),
    basic_led = newResource("Basic LED", "Intermediary Part", 1, 1.25, 1),
    uncommon_led = newResource("Uncommon LED", "Intermediary Part", 2, 1.27, 1),
    advanced_led = newResource("Advanced LED", "Intermediary Part", 3, 1.32, 1),
    basic_pipe = newResource("Basic Pipe", "Intermediary Part", 1, 2.4, 1),
    uncommon_pipe = newResource("Uncommon Pipe", "Intermediary Part", 2, 2.32, 1),
    advanced_pipe = newResource("Advanced Pipe", "Intermediary Part", 3, 2.19, 1),
    basic_screw = newResource("Basic Screw", "Intermediary Part", 1, 8.05, 1),
    uncommon_screw = newResource("Uncommon Screw", "Intermediary Part", 2, 7.9, 1),
    advanced_screw = newResource("Advanced Screw", "Intermediary Part", 3, 8.14, 1),
    basic_antimatter_capsule = newResource("Basic Anti-Matter Capsule", "Complex Part", 1, 24, 4.6),
    uncommon_antimatter_capsule = newResource("Uncommon Anti-Matter Capsule", "Complex Part", 2, 24.32, 4.6),
    advanced_antimatter_capsule = newResource("Advanced Anti-Matter Capsule", "Complex Part", 3, 24.88, 4.6),
    rare_antimatter_capsule = newResource("Rare Anti-Matter Capsule", "Complex Part", 4, 25.8, 4.6),
    exotic_antimatter_capsule = newResource("Exotic Anti-Matter Capsule", "Complex Part", 5, 26.73, 4.6),
    basic_burner = newResource("Basic Burner", "Complex Part", 1, 50.2, 10),
    uncommon_burner = newResource("Uncommon Burner", "Complex Part", 2, 49.4, 10),
    advanced_burner = newResource("Advanced Burner", "Complex Part", 3, 48.5, 10),
    basic_electronics = newResource("Basic Electronics", "Complex Part", 1, 5.22, 4),
    uncommon_electronics = newResource("Uncommon Electronics", "Complex Part", 2, 5.34, 4),
    advanced_electronics = newResource("Advanced Electronics", "Complex Part", 3, 5.45, 4),
    rare_electronics = newResource("Rare Electronics", "Complex Part", 4, 5.63, 4),
    exotic_electronics = newResource("Exotic Electronics", "Complex Part", 5, 5.77, 4),
    basic_explosive_module = newResource("Basic Explosive Module", "Complex Part", 1, 18.72, 4.6),
    uncommon_explosive_module = newResource("Uncommon Explosive Module", "Complex Part", 2, 19.04, 4.6),
    advanced_explosive_module = newResource("Advanced Explosive Module", "Complex Part", 3, 19.04, 4.6),
    basic_hydraulics = newResource("Basic Hydraulics", "Complex Part", 1, 28.95, 10),
    uncommon_hydraulics = newResource("Uncommon Hydraulics", "Complex Part", 2, 28.35, 10),
    advanced_hydraulics = newResource("Advanced Hydraulics", "Complex Part", 3, 29.02, 10),
    basic_injector = newResource("Basic Injector", "Complex Part", 1, 20.3, 10),
    uncommon_injector = newResource("Uncommon Injector", "Complex Part", 2, 20.5, 10),
    advanced_injector = newResource("Advanced Injector", "Complex Part", 3, 20.45, 10),
    basic_magnet = newResource("Basic Magnet", "Complex Part", 1, 63.3, 7.36),
    uncommon_magnet = newResource("Uncommon Magnet", "Complex Part", 2, 62.1, 7.36),
    advanced_magnet = newResource("Advanced Magnet", "Complex Part", 3, 63.89, 7.36),
    rare_magnet = newResource("Rare Magnet", "Complex Part", 4, 64.4, 7.36),
    exotic_magnet = newResource("Exotic Magnet", "Complex Part", 5, 65.13, 7.36),
    basic_optics = newResource("Basic Optics", "Complex Part", 1, 9.74, 10),
    uncommon_optics = newResource("Uncommon Optics", "Complex Part", 2, 9.94, 10),
    advanced_optics = newResource("Advanced Optics", "Complex Part", 3, 10.18, 10),
    rare_optics = newResource("Rare Optics", "Complex Part", 4, 10.7, 10),
    basic_power_system = newResource("Basic Power System", "Complex Part", 1, 60, 9.2),
    uncommon_power_system = newResource("Uncommon Power System", "Complex Part", 2, 62.4, 9.2),
    advanced_power_system = newResource("Advanced Power System", "Complex Part", 3, 64.9, 9.2),
    rare_power_system = newResource("Rare Power System", "Complex Part", 4, 78.31, 9.2),
    exotic_power_system = newResource("Exotic Power System", "Complex Part", 5, 82.87, 9.2),
    basic_processor = newResource("Basic Processor", "Complex Part", 1, 14.84, 5),
    uncommon_processor = newResource("Uncommon Processor", "Complex Part", 2, 15.56, 5),
    advanced_processor = newResource("Advanced Processor", "Complex Part", 3, 15.56, 5),
    exotic_processor = newResource("Exotic Processor", "Complex Part", 5, 21.47, 5),
    basic_quantum_core = newResource("Basic Quantum Core", "Complex Part", 1, 10.72, 5),
    uncommon_quantum_core = newResource("Uncommon Quantum Core", "Complex Part", 2, 11.04, 5),
    advanced_quantum_core = newResource("Advanced Quantum Core", "Complex Part", 3, 11.24, 5),
    rare_quantum_core = newResource("Rare Quantum Core", "Complex Part", 4, 11.66, 5),
    exotic_quantum_core = newResource("Exotic Quantum Core", "Complex Part", 5, 11.66, 5),
    basic_singularity_container = newResource("Basic Singularity Container", "Complex Part", 1, 45.36, 4),
    uncommon_singularity_container = newResource("Uncommon Singularity Container", "Complex Part", 2, 44.88, 4),
    advanced_singularity_container = newResource("Advanced Singularity Container", "Complex Part", 3, 46.22, 4),
    rare_singularity_container = newResource("Rare Singularity Container", "Complex Part", 4, 46.58, 4),
    exotic_singularity_container = newResource("Exotic Singularity Container", "Complex Part", 5, 46.98, 4),
    uncommon_solid_warhead = newResource("Uncommon Solid Warhead", "Complex Part", 2, 45.36, 5),
    advanced_solid_warhead = newResource("Advanced Solid Warhead", "Complex Part", 3, 46.43, 5),
}
for key, resource in pairs(resources) do
    resources[key] = nil
    resources[makeResourceKey(key)] = resource
end

categories = {"ore", "pure", "product", "intermediary_part", "complex_part"}
resourcesForDisplay = {}

for tier = 1, 5 do
    resourcesForDisplay[tier] = {}
    for k, category in pairs(categories) do
        resourcesForDisplay[tier][makeResourceKey(category)] = {}
    end
end

for k, resource in pairs(resources) do
    table.insert(resourcesForDisplay[resource.tier][makeResourceKey(resource.category)], resource)
end
