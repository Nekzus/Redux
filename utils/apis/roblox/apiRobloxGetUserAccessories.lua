--[[
	{
	"previousPageCursor": null,
	"nextPageCursor": "3904560777_1_9a683caaf7242bb499f03def2120d446",
	"data": [
		{
			"assetName": "The High Seas: Beatrix The Pirate Queen - Hat",
			"userAssetId": 29571686028,
			"assetId": 2493718915,
			"owner": {
				"userId": 110839429,
				"username": "Nekzus",
				"buildersClubMembershipType": 0
			},
			"created": "2018-10-28T09:37:59.397",
			"updated": "2018-10-28T09:37:59.397"
		},
		{
			"assetName": "Knights of Redcliff: Paladin - Helmet",
			"userAssetId": 29230797508,
			"assetId": 2493590711,
			"owner": {
				"userId": 110839429,
				"username": "Nekzus",
				"buildersClubMembershipType": 0
			},
			"created": "2018-10-23T17:26:56.28",
			"updated": "2018-10-23T17:26:56.28"
		},
	]
]]

function apiRobloxGetUserAccessories(id, amount)
	assert(id, "Must provide a valid ID")

	local result = {}
	local nextPage = ""

	amount = amount or 100

	local assetTypes = {"8", "41", "42", "43", "44", "45", "46", "47"}

	for _, assetType in next, assetTypes do
		while true do
			local data, request = httpGet(
				"robloxGetUserAccessories",
				query.urlencode(id),
				query.urlencode(assetType),
				query.urlencode(amount),
				query.urlencode(nextPage)
			)

			local decode = json.decode(request)

			if not decode then
				client:error("Unable to decode apiRobloxGetUserAccessories")
				break
			elseif not decode.data then
				break
			end

			for _, tab in next, decode.data do
				table.insert(result, tab)
			end

			if decode.nextPageCursor and amount == 100 then
				nextPage = decode.nextPageCursor
			else
				break
			end
		end
	end

	return result
end

return apiRobloxGetUserAccessories

--[[
Name	Value	Description
Image
1
The asset is an image.

TeeShirt
2
The asset is a T-Shirt.

Audio
3
The asset is an audio clip.

Mesh
4
The asset is a mesh.

Lua
5
The asset is Lua code (e.g. a ModuleScript).

Hat
8
The asset is a hat.

Place
9
The asset is a place.

Model
10
The asset is a model.

Shirt
11
The asset is a shirt.

Pants
12
The asset is a pants item.

Decal
13
The asset is a decal (image).

Head
17
The asset is a head.

Face
18
The asset is a face.

Gear
19
The asset is a gear item.

Badge
21
The asset is a badge.

Animation
24
The asset is an animation (more specific animation type enums below).

Torso
27
The asset is a torso.

RightArm
28
The asset is a right arm.

LeftArm
29
The asset is a left arm.

LeftLeg
30
The asset is a left leg.

RightLeg
31
The asset is a right leg.

Package
32
The asset is a pack (e.g. animation package).

GamePass
34
The asset is a GamePass.

Plugin
38
The asset is a plugin.

MeshPart
40
The asset is a mesh part.

HairAccessory
41
The asset is a hair accessory.

FaceAccessory
42
The asset is a face accessory.

NeckAccessory
43
The asset is a neck accessory.

ShoulderAccessory
44
The asset is a shoulder accessory.

FrontAccessory
45
The asset is a front accessory.

BackAccessory
46
The asset is a back accessory.

WaistAccessory
47
The asset is a waist accessory.

ClimbAnimation
48
The asset is a climb animation.

DeathAnimation
49
The asset is a death animation.

FallAnimation
50
The asset is a fall animation.

IdleAnimation
51
The asset is an idle animation.

JumpAnimation
52
The asset is a jump animation.

RunAnimation
53
The asset is a run animation.

SwimAnimation
54
The asset is a swim animation.

WalkAnimation
55
The asset is a walk animation.

PoseAnimation
56
The asset is a pose animation.

EarAccessory
57
The asset is an ear accessory.

EyeAccessory
58
The asset is an eye accessory.

EmoteAnimation
61
The asset is an emote animation.
]]
