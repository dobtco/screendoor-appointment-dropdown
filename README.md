Screendoor Appointment Dropdown
----

This is a simple integration that allows for adding an "appointment time" dropdown to your Screendoor forms. Once an appointment time is chosen, it is no longer available to other respondents.

## How it works

- Create a Screendoor project. If you'd like, you can use the included project template
- Fork this app and customize the `days_of_week` and `timeslots` methods in `server.rb`. (Unless your appointments happen to fall on Mondays and Tuesdays between 1-4pm!)
- Deploy this app on Heroku or another server. Be sure to set the environment variables specified in `.env.example`
- Embed your form using the code in `test.html`
- When a respondent selects a time slot, it will no longer be available to other respondents.

*Note:* Because we cache the response returned from Screendoor's API, there will be a 1-3 minute delay before the selected option is removed from the dropdown.

## License

MIT
