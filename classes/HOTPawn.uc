class HOTPawn extends UTPawn;

var bool bInvulnerable;
var float InvulnerableTime;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if(ArmsMesh[0] != none)
        ArmsMesh[0].SetHidden(true);
    if(ArmsMesh[1] != none)
        ArmsMesh[1].SetHidden(true);
}

simulated function SetMeshVisibility(bool bVisible)
{
    super.SetMeshVisibility(bVisible);
    Mesh.SetOwnerNoSee(false);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
    if(HOTEnemy(Other) != none && !bInvulnerable)
    {
        bInvulnerable = true;
        SetTimer(InvulnerableTime, false, 'EndInvulnerable');
        TakeDamage(HOTEnemy(Other).BumpDamage, none, Location, vect(0,0,0), class'UTDmgType_LinkPlasma');
    }
}

function EndInvulnerable()
{
    bInvulnerable = false;
}

defaultproperties
{
    InvulnerableTime=0.6
}
