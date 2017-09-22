#include <sourcemod>
#include <sdktools>
 
#pragma newdecls required
#pragma semicolon 1

#define TAG_MESSAGE "[\x02VIP\x01]"
#define TOKEN_LIMIT 6

static const char vipCodes[][] =
{
	"adszxc",
	"moomoo",
};

static const char developerArgs[][] =
{
	"debug",
};

static const char tokenCharacters[][] =
{
	"a", "b", "c", "d", "e", "f",
	"g", "h", "i", "j", "k", "l",
	"m", "n", "o", "p", "q", "r",
	"s", "t", "u", "v", "w", "x",
	"y", "z", "A", "B", "C", "D",
	"E", "F", "G", "H", "I", "J",
	"K", "L", "M", "N", "O", "P",
	"Q", "R", "S", "T", "U", "V",
	"W", "X", "Y", "Z", "0", "1",
	"2", "3", "4", "5", "6", "7",
	"8", "9"
};

public Plugin myinfo =
{
    name = "Give VIP",
    author = "B3none",
    description = "Temporarily give players VIP in the server.",
    version = "0.1.2",
    url = "https://forums.alliedmods.net/showthread.php?t=301305"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_vip", checkCode);
	RegAdminCmd("sm_addstatus", addStatus, ADMFLAG_ROOT);
	RegAdminCmd("sm_generate", generateNewCode, ADMFLAG_ROOT);
}

public Action generateNewCode(int client, int args)
{
	char newToken[TOKEN_LIMIT];
	
	char argString[64];
	GetCmdArgString(argString, sizeof(argString));
	
	if (strlen(argString) > 0) {
		for (int i = 0; i <= sizeof(developerArgs); i++) {
			if (argString == developerArgs[i]) {
				
			}
		}
	}
	
	for (int i = 1; i <= TOKEN_LIMIT && strlen(newToken) < TOKEN_LIMIT; i++) {
		Format(newToken, sizeof(newToken), "%s%s", newToken, tokenCharacters[GetRandomInt(1, sizeof(tokenCharacters))]);
	}
	
	char clientName[64];
	GetClientName(client, clientName, sizeof(clientName));
	
	// Add code to database
	
	PrintToChat(client, "%s The generated code is %s", TAG_MESSAGE, newToken);
	LogMessage("%s %s generated code \"%s\"", TAG_MESSAGE, clientName, newToken);
}

public Action checkCode(int client, int args)
{
	char code[64];
	GetCmdArgString(code, sizeof(code));
	
	if (strlen(code) > TOKEN_LIMIT) {
		PrintToChat(client, "%s Invalid token.", TAG_MESSAGE);
		return;
	}
	
	for (int i = 0; i <= sizeof(vipCodes); i++) {
		if (StrEqual(code, vipCodes[i])) {
			addStatus(0, client);
			
			// Remove used code from the database
			
			break;
		}
	}
	
	PrintToChat(client, "%s Invalid token.", TAG_MESSAGE);
}

public Action addStatus(int client, int target)
{
	if ((!IsValidClient(client) && client != 0) || !IsValidClient(target)) {
		return;
	}
	
	
	char clientName[64];
	char targetName[64];
	
	GetClientName(client, clientName, sizeof(clientName));
	GetClientName(target, targetName, sizeof(targetName));
	
	if (CheckCommandAccess(target, "sm_admin_check", ADMFLAG_RESERVATION)) {
		AddUserFlags(target, Admin_Reservation);
	}
	
	if (client == 0) {
		PrintToChatAll("%s %s was granted VIP access via a secret token", TAG_MESSAGE, targetName);
	} else {
		PrintToChatAll("%s %s granted VIP access to %s", TAG_MESSAGE, clientName, targetName);
	}
}

stock bool IsValidClient(int client)
{
	return (client <= 0 || client > MAXPLAYERS+1 || !IsClientInGame(client));
}
