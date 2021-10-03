enum TagDatabase {
    static func allTags () -> [WashingTag] {
        [
            //MARK: Washing
            WashingTag(
                imageNames: ["machine-wash"],
                name: "Lavar à mão ou máquina",
                category: TagCategory.washing),
            WashingTag(
                imageNames: ["machine-wash-permanent-press"],
                name: "Lavagem fraca",
                category: TagCategory.washing),
            WashingTag(
                imageNames: ["machine-wash-delicate"],
                name: "Lavagem delicada",
                category: TagCategory.washing),
            WashingTag(
                imageNames: ["hand-wash"],
                name: "Lavagem à mão",
                category: TagCategory.washing),
             WashingTag(
                 imageNames: ["do-not-wash"],
                 name: "Não lavar",
                 category: TagCategory.washing),
             WashingTag(
                 imageNames: ["do-not-wetclean"],
                 name: "Não lavar com água",
                 category: TagCategory.washing),
             
             //MARK: Bleaching
             WashingTag(
                 imageNames: ["bleach"],
                 name: "Alvejante",
                 category: TagCategory.bleaching),
              WashingTag(
                  imageNames: ["do-not-bleach",
                              "2-do-not-bleach"],
                  name: "Não utilizar alvejante",
                  category: TagCategory.bleaching),
             WashingTag(
                 imageNames: ["non-chlorine-bleach"],
                 name: "Alvejante sem cloro",
                 category: TagCategory.bleaching),
             
             //MARK: Water temperature
              WashingTag(
                  imageNames: ["water-temp-30",
                              "2-water-temp-30"],
                  name: "Temperatura máxima de lavagem 30°C",
                  category: TagCategory.waterTemperature),
             WashingTag(
                 imageNames: ["water-temp-40",
                             "2-water-temp-40"],
                 name: "Temperatura máxima de lavagem 40°C",
                 category: TagCategory.waterTemperature),
             WashingTag(
                 imageNames: ["water-temp-50",
                             "2-water-temp-50"],
                 name: "Temperatura máxima de lavagem 50°C",
                 category: TagCategory.waterTemperature),
             WashingTag(
                 imageNames: ["water-temp-60",
                             "2-water-temp-60"],
                 name: "Temperatura máxima de lavagem 60°C",
                 category: TagCategory.waterTemperature),
             WashingTag(
                 imageNames: ["water-temp-70",
                             "2-water-temp-70"],
                 name: "Temperatura máxima de lavagem 70°C",
                 category: TagCategory.waterTemperature),
             WashingTag(
                 imageNames: ["water-temp-95",
                             "2-water-temp-95"],
                 name: "Temperatura máxima de lavagem 95°C",
                 category: TagCategory.waterTemperature),
             
             //MARK: Ironing
             WashingTag(
                 imageNames: ["iron"],
                 name: "Passar a ferro",
                 category: TagCategory.ironing),
             WashingTag(
                 imageNames: ["do-not-iron"],
                 name: "Não passar a ferro",
                 category: TagCategory.ironing),
             WashingTag(
                 imageNames: ["low-temperature"],
                 name: "Passar a ferro temperatura máxima 110°C",
                 category: TagCategory.ironing),
             WashingTag(
                 imageNames: ["medium-temperature"],
                 name: "Passar a ferro temperatura máxima 150°C",
                 category: TagCategory.ironing),
             WashingTag(
                 imageNames: ["high-temperature"],
                 name: "Passar a ferro temperatura máxima 200°C",
                 category: TagCategory.ironing),
             
             //MARK: Drying
             WashingTag(
                 imageNames: ["do-not-dry"],
                 name: "Não secar",
                 category: TagCategory.drying),
             WashingTag(
                 imageNames: ["tumble-dry"],
                 name: "Secadora rotativa",
                 category: TagCategory.drying),
             WashingTag(
                 imageNames: ["low-heat",],
                 name: "Secadora rotativa em baixa temperatura",
                 category: TagCategory.drying),
             WashingTag(
                 imageNames: ["medium-heat"],
                 name: "Secadora rotativa em média temperatura",
                 category: TagCategory.drying),
             WashingTag(
                 imageNames: ["high-heat"],
                 name: "Secadora rotativa em alta temperatura",
                 category: TagCategory.drying),
            WashingTag(
                imageNames: ["no-heat"],
                name: "Secar a frio",
                category: TagCategory.drying),
            WashingTag(
                imageNames: ["permanent-press"],
                name: "Secagem fraca",
                category: TagCategory.drying),
            WashingTag(
                imageNames: ["delicate"],
                name: "Secagem delicada",
                category: TagCategory.drying),
            WashingTag(
                imageNames: ["hang-to-dry"],
                name: "Secar pendurado no cabide",
                category: TagCategory.drying),
            WashingTag(
                imageNames: ["drip-dry"],
                name: "Secar no varal",
                category: TagCategory.drying),
             WashingTag(
                 imageNames: ["do-not-wring"],
                 name: "Não torcer",
                 category: TagCategory.drying),
             
             //MARK: Dry cleaning
            WashingTag(
                imageNames: ["dry-short-cycle"],
                name: "Limpar a seco em ciclo curto",
                category: TagCategory.dryCleaning),
            WashingTag(
                imageNames: ["dry-reduced-moisture"],
                name: "Limpar a seco em redução de umidade",
                category: TagCategory.dryCleaning),
             WashingTag(
                 imageNames: ["dry-low-heat"],
                 name: "Limpar a seco com calor baixo",
                 category: TagCategory.dryCleaning),
             WashingTag(
                 imageNames: ["dry-no-steam-finishing"],
                 name: "Limpar a seco sem vapor",
                 category: TagCategory.dryCleaning),
              WashingTag(
                  imageNames: ["dryclean"],
                  name: "Limpar a seco em lavanderia",
                  category: TagCategory.dryCleaning),
             WashingTag(
                 imageNames: ["dry-any-solvent"],
                 name: "Limpar a seco em lavanderia com qualquer solvente",
                 category: TagCategory.dryCleaning),
              WashingTag(
                  imageNames: ["dry-any-solvent-except-tetrachlorethylene",
                              "dry-petroleum-solvent-only"],
                  name: "Limpar a seco em lavanderia com solvente específico",
                  category: TagCategory.dryCleaning)
        ]
        
    }
}
