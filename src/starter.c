#include "../include/script.h"
#include "../include/pokemon.h"

void LONG_CALL Save_VarsFlags_SetStarter(void *state, u16 starter);

BOOL ScrCmd_SetStarterChoice(SCRIPTCONTEXT *ctx) {
    u16 choice = ScriptGetVar(ctx);
    Save_VarsFlags_SetStarter(SaveData_GetEventPtr(ctx->fsys->savedata), choice);

    void * party = SaveData_GetPlayerPartyPtr(ctx->fsys->savedata);
    struct PartyPokemon *partyMon = Party_GetMonByIndex(party, 0);

    u16 perfectIV = 31;
    u8 setIVs = 0;
    BOOL isIVset[6] = {FALSE, FALSE, FALSE, FALSE, FALSE, FALSE};
    u16 stat;

    while(setIVs < 3) {
        stat = gf_rand() % 6;

        if (!isIVset[stat])
        {
            SetMonData(partyMon, MON_DATA_HP_IV + stat, &perfectIV);
            isIVset[stat] = TRUE;
            setIVs++;
        }
        
    }


    return FALSE;
}