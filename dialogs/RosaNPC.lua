local EventBus = require "classes.EventBus"

local npcName = "Rosita valenzuela"
return {
    npcName = "Rosita valenzuela",
    dialogs = {
        {
            list = true,
            messages = {
                {
                    message = "Hola"
                },
                {
                    message = "Mi nombre es " .. npcName
                },
                {
                    message = "¿Podría saber que haces por aqui? -- Por tu vestimenta no parece que seas de por aqui",
                    options = {
                        {
                            "Soy de rancho",
                            function()
                                EventBus.getInstance()
                                    :dispatchEvent("NextDialog", {
                                        npcName = npcName,
                                        dialog = 2
                                    })
                            end
                        },
                        {
                            "Vengo de un pueblo muy lejano!",
                            function()
                                EventBus.getInstance()
                                    :dispatchEvent("NextDialog", {
                                        npcName = npcName,
                                        dialog = 3
                                    })
                            end
                        }
                    }
                },
            }
        },
        {
            list = true,
            messages = {
                {
                    message = "Mmmm no me pareces alguien de rancho",
                },
                {
                    message = "Pero bueno... -- espero que tengas una buena visita por aqui!",
                }
            }
        },
        {
            list = true,
            messages = {
                {
                    message = "Ya decia yo",
                },
                {
                    message = "Espero que tengas una buena visita por aqui!",
                }
            }
        }
    }
}
