SLASH_WOOGLE1, SLASH_WOOGLE2 = '/woogle', '/woo';    

BAG_MIN = 0;
BAG_MAX = 4;

SLOT_ZERO  = 0;
SLOT_ONE   = 0;
SLOT_TWO   = 0;
SLOT_THREE = 0;
SLOT_FOUR  = 0;

Bag_Slot_Info = {};                 
           
local SYSTEM_MESSAGES =
{
	["FOUND"] 		 	= "Woogle found:",
	["NOTFOUND"]	 	= "Woogle did not find item matching: ",
	["REFRESH"]		 	= "Woogle refreshing cache to try again.",
	["SYNTAX"]	   	 	= "Syntax: /woogle <some_item>",
	["LOADER"]		 	= "Woogle 1.1 is now loaded and ready to find what you need!",
	["USAGE"]		 	= "Woogle Syntax: /woogle or /woo item", 
	["DICTIONARY"] 	 	= "Woogle has cached your bag items",
	["STARTSEARCH"]	 	= "Beginning search for item:"
};      

function LoadBags()

	SLOT_ZERO  = GetContainerNumSlots(0);
	SLOT_ONE   = GetContainerNumSlots(1);
	SLOT_TWO   = GetContainerNumSlots(2);
	SLOT_THREE = GetContainerNumSlots(3);
	SLOT_FOUR  = GetContainerNumSlots(4);

	Bag_Slot_Info =
	{
		[0] = SLOT_ZERO,
		[1] = SLOT_ONE,
		[2] = SLOT_TWO,
		[3] = SLOT_THREE,
		[4] = SLOT_FOUR
	};

	return true;      
end
                  
function handler(item, editBox)
	if strlen(item) > 0 then  
		if item:find("help") then
			GetHelp();
		else
			CloseAllBags(); 
			if LoadBags() == true then
				UpdateChatFrames(SYSTEM_MESSAGES["STARTSEARCH"] .. " " ..item);
		
				local itemCapital = item:gsub("^%l", string.upper);
				FindContainerItemByName(itemCapital); 
			end    
		end
	else
		UpdateChatFrames(SYSTEM_MESSAGES["SYNTAX"]);
	end  
end
SlashCmdList["WOOGLE"] = handler;

function FindContainerItemByName(search)
	local isFound = false;
	for bag = BAG_MIN,BAG_MAX do
	   	for slot = 1,Bag_Slot_Info[bag] do
	     	local item = GetContainerItemLink(bag,slot);
	     	if  item and item:find(search) then
				isFound = true; 	
       			PickupContainerItem(bag,slot);
				UpdateChatFrames(SYSTEM_MESSAGES["FOUND"] .. " " .. item .. " in bag: " .. GetBagName(bag));  
				OpenBag(bag); 
	     	end
	   	end   
	end

	if isFound == false then
		UpdateChatFrames(SYSTEM_MESSAGES["NOTFOUND"] .. " " .. search);
	end  
end
             
function UpdateChatFrames(message)
    DEFAULT_CHAT_FRAME:AddMessage(message);
end

function GetHelp()                          
	SendSystemMessage("----------------"); 
	SendSystemMessage("Woolge Help");     
	SendSystemMessage("----------------");
	SendSystemMessage(SYSTEM_MESSAGES["USAGE"]);    
end

function InitWoogle()
   	
	if 	LoadBags() == true then	  				
		SendSystemMessage(SYSTEM_MESSAGES["LOADER"]);
		SendSystemMessage(SYSTEM_MESSAGES["USAGE"]); 	
	end                                                    
	
end

