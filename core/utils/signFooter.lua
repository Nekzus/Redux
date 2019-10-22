function signFooter(embed, author, lang)
	embed:timestamp(discordia.Date():toISO("T", "Z"))
	embed:footer(parseFormat("${commandRanBy}", langs[lang or config.defaultGuild.lang], author.tag))

	return embed
end

return signFooter
