function signFooter(embed, author, lang)
	embed:timestamp(discordia.Date():toISO("T", "Z"))
	embed:footer(localize("${commandRanBy}", lang, author.tag))

	return embed
end

return signFooter
