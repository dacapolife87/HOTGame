class HOTGame extends UTDeathmatch;

var int EnemiesLeft;
var array<HOTEnemySpawner> EnemySpawners;

var int WaveCounter;
var int RoundCounter;

var float MinSpawnerDistance, MaxSpawnerDistance;

simulated function PostBeginPlay()
{
    local HOTEnemySpawner ES;

    super.PostBeginPlay();

    GoalScore = EnemiesLeft;

    foreach DynamicActors(class'HOTEnemySpawner', ES)
        EnemySpawners[EnemySpawners.length] = ES;

    SetTimer(5.0, false, 'ActivateSpawners');
}

function ActivateSpawners()
{
    local int i;
    local HOTPlayerController PC;

    foreach LocalPlayerControllers(class'HOTPlayerController', PC)
        break;
    if(PC.Pawn == none)
    {
        SetTimer(1.0, false, 'ActivateSpawners');
        return;
    }

    for(i=0; i<EnemySpawners.length; i++)
    {
            if(EnemySpawners[i].CanSpawnEnemy())
                EnemySpawners[i].SpawnEnemy();
    }

        //InRangeSpawners[Rand(InRangeSpawners.length)].SpawnEnemy();


        if(WaveCounter==1){
            WaveCounter=0;
            RoundCounter++;
            SetTimer(20.0, false, 'ActivateSpawners');
            return;
        }
        WaveCounter++;
        SetTimer(5.0, false, 'ActivateSpawners');
}

function ScoreObjective(PlayerReplicationInfo Scorer, Int Score)
{
    local int i;

    EnemiesLeft--;
    super.ScoreObjective(Scorer, Score);

    if(EnemiesLeft == 0)
    {
        for(i=0; i<EnemySpawners.length; i++)
            EnemySpawners[i].MakeEnemyRunAway();
        ClearTimer('ActivateSpawners');
    }
}

defaultproperties
{
  WaveCounter=0
    EnemiesLeft=20
    bScoreDeaths=false
    PlayerControllerClass=class'HOTGame.HOTPlayerController'
    DefaultPawnClass=class'HOTGame.HOTPawn'
    DefaultInventory(0)=None
}
