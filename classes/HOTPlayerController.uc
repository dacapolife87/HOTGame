class HOTPlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var vector CurrentCameraLocation, DesiredCameraLocation;
var rotator CurrentCameraRotation;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    bNoCrosshair = true;
}

exec function Upgrade()
{
    if(Pawn != none && HOTWeapon(Pawn.Weapon) != none)
        HOTWeapon(Pawn.Weapon).UpgradeWeapon();
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    super.NotifyChangedWeapon(PrevWeapon, NewWeapon);

    NewWeapon.SetHidden(true);

    if(Pawn == none)
        return;

    if(UTWeap_RocketLauncher(NewWeapon) != none)
        Pawn.SetHidden(true);
    else
        Pawn.SetHidden(false);
}

exec function StartFire( optional byte FireModeNum )
{
    super.StartFire(FireModeNum);

    if(Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none)
    {
        Pawn.SetHidden(false);
        SetTimer(1, false, 'MakeMeInvisible');
    }
}

function MakeMeInvisible()
{
    if(Pawn != none)
        Pawn.SetHidden(true);
}

simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
    super.GetPlayerViewPoint(out_Location, out_Rotation);

    if(Pawn != none)
    {
        out_Location = CurrentCameraLocation;
        out_Rotation = rotator((out_Location * vect(1,1,0)) - out_Location);
    }

    CurrentCameraRotation = out_Rotation;
}

function PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);

    if(Pawn != none)
    {
        DesiredCameraLocation = Pawn.Location + (PlayerViewOffset >> Pawn.Rotation);
        CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * DeltaTime * 3;
    }
}

function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc )
{
    return Pawn.Rotation;
}

state PlayerWalking
{
    function ProcessMove( float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        local vector X, Y, Z, AltAccel;

        GetAxes(CurrentCameraRotation, X, Y, Z);
        AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe * Y;
        AltAccel.Z = 0;
        AltAccel = Pawn.AccelRate * Normal(AltAccel);
        super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
    }
}

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
    if(myHUD != none)
        myHUD.Destroy();

    myHUD = spawn(class'HOTHUD', self);
}

defaultproperties
{
    PlayerViewOffset=(X=384,Y=0,Z=1024)
}
