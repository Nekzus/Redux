function signFooter(embed, author, lang)
	embed:timestamp(discordia.Date():toISO("T", "Z"))
	embed:footer(localize("${commandRanBy}", lang, author.tag))
end

return signFooter
