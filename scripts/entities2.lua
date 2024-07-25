---@diagnostic disable
---5938 is for jokes ONLY
return function(mode)
    local entities = {{Name="Fivehead",Anm2="monsters/fivehead/fivehead.anm2",Type=161,Variant=0,HP=15,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=28,NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Floater",Anm2="monsters/floater/floater.anm2",Type=161,Variant=1,HP=10,Champion=true,CollisionDamage=1,CollisionMass=10,CollisionRadius=13,ShadowSize=28,NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    --indents exist for reading purposes only
    {Name="Dried",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (Black)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=1,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (White)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=2,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (Brown)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=3,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (Green)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=4,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (Yellow)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=5,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    {Name="Dried (Red)",Anm2="monsters/dried/dried.anm2",Type=90,Variant=1,Subtype=6,HP=13,Champion=false,CollisionDamage=0,CollisionMass=10,CollisionRadius=13,ShadowSize=28,ShutDoors="false",NumGridCollisionPoints=12,ShieldStrength=10,Portrait=32,},
    --end of dried, shoud still be ch. 1
    {Name="Neutral Fly",Anm2="monsters/neutralfly/neutralfly.anm2",Type=161,Variant=3,HP=12,Champion=true,CollisionDamage=1,CollisionMass=6,CollisionRadius=13,ShadowSize=13,NumGridCollisionPoints=8,ShieldStrength=10,Portrait=32,},
    {Name="Erythorcyte",Anm2="monsters/erythorcyte/erythorcyte.anm2",Type=161,Variant=4,Subtype=10,HP=12,Champion=true,CollisionDamage=1,CollisionMass=6,CollisionRadius=13,ShadowSize=13,NumGridCollisionPoints=8,ShieldStrength=10,Portrait=32,},
    {Name="Erythorcytebaby",Anm2="monsters/erythorcyte/erythorcyte.anm2",Type=161,Variant=4,Subtype=11,HP=12,Champion=true,CollisionDamage=1,CollisionMass=6,CollisionRadius=13,ShadowSize=13,NumGridCollisionPoints=8,ShieldStrength=10,Portrait=32,},
    {Name="A gaper w/ three legs, why did we do this",Anm2="jokes/enemies/gaperrr/gaperrr.anm2",Type=10,Variant=5938,HP=10,Champion=true,CollisionDamage=1,CollisionMass=6,CollisionRadius=13,ShadowSize=13,NumGridCollisionPoints=8,ShieldStrength=10,Portrait=32,},}
    if not mode or mode == 1 then
        return entities
    elseif mode == 2 then
        return {["Fivehead"]=entities[1],["Floater"]=entities[2],["Dried"]=entities[3],["Dried (Black)"]=entities[5],["Dried (White)"]=entities[6],["Dried (Brown)"]=entities[7],["Dried (Green)"]=entities[8],["Dried (Yellow)"]=entities[9],["Dried (Red)"]=entities[10],
        ["Neutral Fly"]=entities[4],["Erythorcyte"]=entities[11],["A gaper w/ three legs, why did we do this"]=entities[1024],}
    elseif mode == 3 then
        return {[90]={[1]={[0]=entities[3]}, {[1]=entities[5]}, {[2]=entities[6]},{[3]=entities[7]},{[4]=entities[8]},{[5]=entities[9]},{[6]=entities[10]}},[161]={[0]={[0]=entities[1],},[2]={[0]=entities[2],},[3]={[0]=entities[4],},[4]={[0]=entities[11],},},[10]={[5938]={[0]=entities[1024],}},}
    end
  end