local guiName = "ScriptsCentralGUI"
local apiUrl = "https://modelos-site.vercel.app/scripts"

game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "Central";
    Text = "Adrian75556435";
    Icon = "rbxthumb://type=Asset&id=93638563594123&w=150&h=150"})
Duration = 16;

if identifyexecutor then
    if game:GetService("CoreGui"):FindFirstChild(guiName) then
        return
    end

    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = guiName

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 400, 0, 300)
    Frame.Position = UDim2.new(0.5, -200, 0.5, -150) -- Centro inicial
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true

    local TopBar = Instance.new("Frame", Frame)
    TopBar.Size = UDim2.new(1, 0, 0, 30)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TopBar.Active = true

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -90, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.Text = "Central de Scripts"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local MinimizeButton = Instance.new("TextButton", TopBar)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Text = "-"
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local CloseButton = Instance.new("TextButton", TopBar)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Text = "X"
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

    local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -30)
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 5
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

    local Layout = Instance.new("UIListLayout", ScrollingFrame)
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    local activeScripts = {}

    local function createButton(scriptName)
        local Button = Instance.new("TextButton", ScrollingFrame)
        Button.Size = UDim2.new(1, -10, 0, 50)
        Button.Text = "Ativar: " .. scriptName
        Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        activeScripts[scriptName] = false

        Button.MouseButton1Click:Connect(function()
            if activeScripts[scriptName] then
                -- Desativar o script
                activeScripts[scriptName] = false
                Button.Text = "Ativar: " .. scriptName
                Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                print("Script desativado:", scriptName)
                -- Adicione a lógica para desativar o script aqui, se necessário.
            else
                -- Ativar o script
                activeScripts[scriptName] = true
                Button.Text = "Desativar: " .. scriptName
                Button.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                local scriptUrl = apiUrl .. "/" .. scriptName
                local success, result = pcall(function()
                    return loadstring(game:HttpGet(scriptUrl))()
                end)

                if success then
                    print("Script ativado:", scriptName)
                else
                    warn("Erro ao ativar o script:", result)
                end
            end
        end)
    end

    local success, response = pcall(function()
        return game:HttpGet(apiUrl)
    end)

    if success then
        local scripts = game:GetService("HttpService"):JSONDecode(response)
        for _, scriptName in ipairs(scripts) do
            createButton(scriptName)
        end
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #scripts * 60)
    else
        warn("Erro ao buscar os scripts:", response)
    end

    local isMinimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        if isMinimized then
            Frame.Size = UDim2.new(0, 400, 0, 300)
            MinimizeButton.Text = "-"
        else
            Frame.Size = UDim2.new(0, 400, 0, 30)
            MinimizeButton.Text = "+"
        end
        isMinimized = not isMinimized
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Movimentação completa da GUI
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
else
    print("Este script deve ser executado em um executor externo.")
end