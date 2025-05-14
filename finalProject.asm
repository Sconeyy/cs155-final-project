;   _____________________________________________________
;   \Jackson Gauvin's Final Project: Minecraft Story Game|
;   `---------------------------------------------------'
;         _______________________________________
;    ()==(            Register Dictionary        (@==()
;         '______________________________________'|
;           |                                     |
;           |   r0: stores and displays strings   |
;           |   r1: user choice register          |
;           |   r2: ascii conversion helper       |
;           |   r3: temporary branching logic     |
;         __)_____________________________________|
;    ()==(                                       (@==()
;         '--------------------------------------'

.orig x3000

; === Main program start ===
main
        jsr showMenu         ; Display the main menu
        jsr getFirstChoice   ; Get user input: 1 (Overworld) or 2 (Nether)
        
        ; === Branch based on user's choice ===
        brz story1Jumper     ; If user chose '1' (R1 == 0), go to Overworld
        add r3 r1 #-1        ; Check if input was '2' (R1 == 1)
        brz story2Jumper     ; If so, jump to Nether
        
        br main              ; Otherwise, repeat menu

; === Jump targets for stories ===
story1Jumper
        jsr story1           ; Call Overworld story

story2Jumper
        jsr story2           ; Call Nether story

ascii_1         .fill x31     ; ASCII code for '1'

; === Displays the menu prompt ===
showMenu
        lea r0 menuText      ; Load address of the menu string
        puts                 ; Print the menu
        ret

menuText       .stringz "\n1: Overworld\n2: Nether\nChoose story (1-2): "

; === Gets user input and converts it to a number (0 for '1', 1 for '2') ===
getFirstChoice
        trap x20             ; Get character input from user
        out                  ; Echo the input
        ld r2 ascii_1        ; Load ASCII value of '1'
        not r2 r2
        add r2 r2 #1         ; Negate and increment to compute -ASCII('1')
        add r1 r0 r2         ; Subtract '1' from input -> 0 for '1', 1 for '2'
        ret

; === Overworld story ===
story1
        lea r0 story1Text
        puts
        lea r0 forest1
        puts
        lea r0 forest2
        puts
        lea r0 forest3
        puts

        jsr getForestChoice  ; Get user choice: (1) trees or (2) forest edge
        brz treeJumper       ; If choice is 1 (R1 == 0), jump to tree
        add r3 r1 #-1
        brz edgeJumper       ; If choice is 2 (R1 == 1), jump to edge
        jsr end              ; Invalid input -> end

treeJumper
    jsr tree

edgeJumper
    jsr edge

story1Text      .stringz "\nOverworld...\n"
forest1         .stringz "\nYou wake in a forest."
forest2         .stringz "\nYou have nothing—no tools, no shelter.\n"
forest3         .stringz "\n(1) Punch some trees\n(2) Explore the forest edge\nChoice: "

; === Gets choice for forest options (1 or 2) ===
getForestChoice
    trap x20
    out
    lea r3 ascii_1_local
    ldr r2 r3 #0             ; Load ASCII '1'
    not r2 r2
    add r2 r2 #1
    add r1 r0 r2             ; Convert to number: 0 or 1
    ret

ascii_1_local   .fill x31

; === If user chose to punch trees ===
tree
    lea r0 treeText1
    puts
    lea r0 treeText2
    puts
    jsr getTreeChoice        ; (1) build house, (2) mine cave
    brz houseJumper
    add r3 r1 #-1
    brz caveJumper
    jsr end

houseJumper
    jsr house

caveJumper
    jsr cave

treeText1        .stringz "\nYou took down a few trees and now have basic tools."
treeText2        .stringz "\n(1) Build a house\n(2) Mine in a cave\nChoice: "

getTreeChoice
    trap x20
    out
    lea r3 ascii_1_local_tree
    ldr r2 r3 #0
    not r2 r2
    add r2 r2 #1
    add r1 r0 r2
    ret

ascii_1_local_tree  .fill x31

house
    lea r0 houseText
    puts
    jsr end

houseText      .stringz "\nYou build a beautiful house with wooden materials."

cave
    lea r0 caveText
    puts
    jsr end

caveText       .stringz "\nYou explore the cave with wooden tools and collect minerals."

; === If user chose forest edge ===
edge
    lea r0 edgeText1
    puts
    lea r0 edgeText2
    puts
    jsr getEdgeChoice        ; (1) go to village, (2) go to lake
    brz villageJumper
    add r3 r1 #-1
    brz lakeJumper
    jsr end

villageJumper
    jsr village

lakeJumper
    jsr lake

edgeText1      .stringz "\nAt the edge of the forest,\nyou see a village and a lake."
edgeText2      .stringz "\n(1) Head to the village\n(2) Head to the lake\nChoice: "

getEdgeChoice
    trap x20
    out
    lea r3 ascii_1_local_edge
    ldr r2 r3 #0
    not r2 r2
    add r2 r2 #1
    add r1 r0 r2
    ret

ascii_1_local_edge  .fill x31

village
    lea r0 villageText1
    puts
    jsr end

villageText1        .stringz "\nYou talk to the villagers in the village and trade for crops."

lake
    lea r0 lakeText1
    puts
    jsr end

lakeText1           .stringz "\nYou fish cod and salmon in the lake for dinner."

; === Nether story ===
story2
        lea r0 story2Text
        puts
        lea r0 nether1
        puts
        lea r0 nether2
        puts
        lea r0 nether3
        puts
        jsr getNetherChoice   ; (1) go to fortress, (2) go to bastion
        brz fortressJumper
        add r3 r1 #-1
        brz bastionJumper
        jsr end

fortressJumper
        jsr fortress

bastionJumper
        jsr bastion

story2Text      .stringz "\nNether...\n"
nether1         .stringz "\nThere is a split in the nether terrain."
nether2         .stringz "\nA fortress on your left, a bastion on your right."
nether3         .stringz "\n(1) Go to fortress\n(2) Go to bastion\nChoice: "

; === Gets user choice for Nether options ===
getNetherChoice
    trap x20
    out
    lea r3 ascii_1_local_nether
    ldr r2 r3 #0
    not r2 r2
    add r2 r2 #1
    add r1 r0 r2
    ret

ascii_1_local_nether .fill x31

fortress
    lea r0 fortressText
    puts
    jsr end

fortressText       .stringz "\nYou find blaze rods and bones in the fortress."

bastion
    lea r0 bastionText
    puts
    jsr end

bastionText        .stringz "\nYou find gold and armor trims in the bastion."

; === Program ends ===
end
        halt

.end

;.___________. __    __       ___      .__   __.  __  ___      _______.
;|           ||  |  |  |     /   \     |  \ |  | |  |/  /     /       |
;`---|  |----`|  |__|  |    /  ^  \    |   \|  | |  '  /     |   (----`
;    |  |     |   __   |   /  /_\  \   |  . `  | |    <       \   \    
;    |  |     |  |  |  |  /  _____  \  |  |\   | |  .  \  .----)   |   
;    |__|     |__|  |__| /__/     \__\ |__| \__| |__|\__\ |_______/    
;
;                    _______   ______   .______      
;                   |   ____| /  __  \  |   _  \     
;                   |  |__   |  |  |  | |  |_)  |    
;                   |   __|  |  |  |  | |      /     
;                   |  |     |  `--'  | |  |\  \----.
;                   |__|      \______/  | _| `._____|
;
;  .______    __          ___   ____    ____  __  .__   __.   _______ 
;  |   _  \  |  |        /   \  \   \  /   / |  | |  \ |  |  /  _____|
;  |  |_)  | |  |       /  ^  \  \   \/   /  |  | |   \|  | |  |  __  
;  |   ___/  |  |      /  /_\  \  \_    _/   |  | |  . `  | |  | |_ | 
;  |  |      |  `----./  _____  \   |  |     |  | |  |\   | |  |__| | 
;  | _|      |_______/__/     \__\  |__|     |__| |__| \__|  \______|