local EventBus = require 'classes.EventBus'

local npcName = "TEST"
return {
    npcName = npcName,
    dialogs = {
        {
            message = "Mensaje 1",
            options = {
                {
                    "Ir a opcion 2",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 2
                            })
                    end
                },
                {
                    "Ir a opcion 3",
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
        {
            message = "Mensaje 2",
            options = {
                {
                    "Ir a opcion 4",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 4
                            })
                    end
                },
                {
                    "Ir a opcion 5",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 5
                            })
                    end

                },
                {
                    "Ir a opcion 6",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 6
                            })
                    end
                }
            }
        },
        {
            message = "Mensaje 3",
            options = {
                {
                    "Salir",
                    function()
                        love.event.quit()
                    end
                }
            }
        },
        {
            message = "Mensaje 4",
            options = {
                {
                    "Ir a opcion 7",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 7
                            })
                    end
                }
            }
        },
        {
            message = "Mensaje 5",
            options = {
                {
                    "Salir",
                    function()
                        love.event.quit()
                    end
                }
            }
        },
        {
            message = "Mensaje 6",
            options = {
                {
                    "Ir a opcion 3",
                    function()
                        EventBus.getInstance()
                            :dispatchEvent("NextDialog", {
                                npcName = npcName,
                                dialog = 3
                            })
                    end
                },
                {
                    "Salir",
                    function()
                        love.event.quit()
                    end
                }
            }
        },
        {
            message = "Mensaje 7",
            options = {
                {
                    "Salir",
                    function()
                    end
                }
            }
        },
    }
}
