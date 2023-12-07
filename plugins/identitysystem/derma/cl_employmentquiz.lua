local PANEL = {}
local PLUGIN = PLUGIN

local applications = {} -- Define and initialize the 'applications' table

function PANEL:Init()
    self:SetSize(ScrW() / 4, 400)
    self:Center()
    self:SetTitle("")
    self:MakePopup()
    self:SetBackgroundBlur(true)

    local quizData = {
        {
            question = "Yes",
            options = {
                {
                    text = "I think so",
                    correct = true
                },
                {
                    text = "Maybe?",
                    correct = false
                },
                {
                    text = "Yes",
                    correct = true
                },
                {
                    text = "No",
                    correct = false
                }
            }
        },
        {
            question = "No",
            options = {
                {
                    text = "Yes",
                    correct = false
                },
                {
                    text = "No",
                    correct = true
                },
                {
                    text = "Maybe",
                    correct = false
                },
                {
                    text = "Shouldn't be",
                    correct = true
                }
            }
        }
    }

    local currentQuestion = 1
    local correctAnswers = 0

    local function LoadQuestion()
        local questionData = quizData[currentQuestion]
        self.questionLabel:SetText(questionData.question)

        if self.optionButtons then
            for _, button in ipairs(self.optionButtons) do
                button:Remove()
            end
        end

        self.optionButtons = {}
        local yOffset = 80

        for i, option in ipairs(questionData.options) do
            local optionButton = vgui.Create("DButton", self)
            optionButton:SetText(option.text)
            optionButton:SetPos(20, yOffset)
            optionButton:SetSize(360, 30)

            optionButton.DoClick = function()
                if option.correct then
                    correctAnswers = correctAnswers + 1
                    print("Correct answer!")
                    -- Add your desired actions for a correct answer here
                else
                    print("Wrong answer!")
                    -- Add your desired actions for a wrong answer here
                end

                currentQuestion = currentQuestion + 1

                if currentQuestion <= #quizData then
                    LoadQuestion()
                else
                    if correctAnswers == #quizData then
                        local frame = vgui.Create("DFrame")
                        frame:SetSize(400, 300)
                        frame:Center()
                        frame:SetTitle("Join Civil Protection")
                        frame:SetVisible(true)
                        frame:SetDraggable(false)
                        frame:ShowCloseButton(true)
                        frame:MakePopup()

                        local questionLabel = vgui.Create("DLabel", frame)
                        questionLabel:SetPos(10, 30)
                        questionLabel:SetText("Why do you want to join Civil Protection?")
                        questionLabel:SetSize(380, 20)

                        local answerTextBox = vgui.Create("DTextEntry", frame)
                        answerTextBox:SetPos(10, 50)
                        answerTextBox:SetSize(380, 200)
                        answerTextBox:SetMultiline(true)

                        local remainingCharsLabel = vgui.Create("DLabel", frame)
                        remainingCharsLabel:SetPos(10, 260)
                        remainingCharsLabel:SetText("Characters Remaining: 1600")
                        remainingCharsLabel:SetSize(380, 20)

                        answerTextBox.OnChange = function(self)
                            local text = self:GetValue()
                            local remainingChars = 1600 - string.len(text)
                            remainingCharsLabel:SetText("Characters Remaining: " .. remainingChars)
                            if remainingChars < 0 then
                                self:SetText(string.sub(text, 1, 1600))
                            end
                        end

                        local submitButton = vgui.Create("DButton", frame)
                        submitButton:SetPos(10, 280)
                        submitButton:SetSize(380, 20)
                        submitButton:SetText("Submit")

                        local applicationText = ""

                        submitButton.DoClick = function()
                            applicationText = answerTextBox:GetValue() -- Store the answer text
                            netstream.Start("SubmitCPPaper", applicationText) -- Send the application text via NetStream
                            frame:Close()
                        end                                           
                    end

                    self:Close()
                end
            end

            yOffset = yOffset + 40
            table.insert(self.optionButtons, optionButton)
        end
    end

    self.questionLabel = vgui.Create("DLabel", self)
    self.questionLabel:SetPos(20, 40)
    self.questionLabel:SetSize(360, 20)
    LoadQuestion()
end

vgui.Register("ixJobQuiz", PANEL, "DFrame")
