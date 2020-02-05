# NetShooter
#### Made by: Thies Nieborg. Some ideas by: Jacco v N.

## Original idea
You spawn in a map which is grid based. There are several point of interest(Pokemon-gyms).
You are a tech nerd and you start with a machine. You choose between 3 standard devices (Galaxy s5, Ipohne 6, Nokia 3310)
1. When you choose your phone you start with explore the map.
2. FInd hacker
3. Fight the hacker
4. Get XP from defeated device
5. Level up your device
6. Start exploring further

### Techincal
The map is divided in chunks(32x32 tiles). It is stored in JSON and is loaded into the tilemap.
Stored like: {x: 0, y: 0, data: [[0,0,0,...], ...], amountPoi: 4, conn: [0,1,2]}
Conn is connection with other chunks. 0=north, 1=east, 2=south, 3=west
Each chunk creates a route between POI's and sides, so it can connect with other chunks.


### POI Idea's
* People
  * Hackers (Battle them for XP, Have drones circling around them(You can dodge or fight them) to protect)
  * Engineers(Ask them to help you. Different types: Mechanical(Repair devices), Chemical(Increase teamwork), Civil(Increase the likelyhood that other NPC will help you), Management(Incease carrying capacity), Geotechnical(Increase kernel stability?), Electrical(Increase damage))
  
* Gym's
  * Updateinator: Update your pokemon's(They will get better defense)
  * DownloadMoreRam: Better capacity(More storage for attacks)
  * BatteryRefresh: Get extra energy for device
  * 

* Other
  * Rewards(Free hidden items which will earn you xp, money or energy)


### XP
#### PlayerXP
You can invest XP into your abilities to level them. They will get faster, give better result, 

#### DeviceXP


### Abilities
Abilties are general and can be used at any time. (They have a range of course)
* nmap: scan for vurnerabilities in your opponent
* ifconfig: learn about your own strengths

*The rest of kali linux tools*

### UI
You have just the normal pokemon UI, but you also have a terminal.
In the terminal you can run all kinds commands.
#### Commands
* ls = list all machine's
* 

### Fighting
You have different types machines(Pokemons) and they have sub-abilities.
You also have evolutions: Linux(Different Distro's), Windows( WIndows 98, WIndows, 7), MacOS()

Every Machine also has levels which represent the hardware(Better cpu with higher level)

### Machine Types
* Linux
    * Legendary
    * Very fast
    * You have to be high-level to use it correctly
    * Cryptic errors

* Windows
    * Uncommon
    * Slow
    * Lots of evolutions
    * Easy to customize
    * Crashes often

* MacOS
    * Rare
    * Versatile
    * Easy to use
    * Gets strength boost when coupled with IOS
   
 * IOS
    * Uncommon
    * Gets strength boost when coupled with MacOS
    
* Android
    * Common
    * Lots of evolutions
    * Easy to use
    
### Example Machines
* Hackintosh( Windows machine with MACOS type)
* Surface laptop
* Macbook air
* Samsung phone
* Iphone 11
* $Rooted android
* Galaxy fold


### Evolutions
* Linux
    * Manjaro(Fast, hard to use)
    * Ubuntu(Medium, Easy to use)
    * 

* Windows
    * Different windows versions
    
* Macos/IOS
    * MacOs Catilane
    * Macos
    
* Android
    * Rooted
    * 4.4, 6, 7, 8, 10
    
