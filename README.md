Screendoor Appointment Dropdown
----

This is a simple integration that allows for adding an "appointment time" dropdown to your [Screendoor](https://www.dobt.co/screendoor/) forms. Once an appointment time is chosen, it is no longer available to other respondents.

The appointment times are generated based on the current date. By default, appointments can be made more than one week, but no further than one month in advance. Appointments are available on Mondays and Tuesdays between 1-4pm.

These parameters were chosen at random -- to customize to your use case, you should fork this repo and modify the methods in `server.rb`.

## Demo

[View a live demo &rarr;](http://output.jsbin.com/ribeyo)

## Deployment

1. Create a Screendoor project. If you'd like, you can use the included project template
2. Deploy this app on Heroku or another server. Be sure to set the environment variables specified in `.env.example`
3. Embed your form using the code in `test.html`
4. When a respondent selects a time slot, it will no longer be available to other respondents.

*Note:* Because we cache the response returned from Screendoor's API, there will be a 1-3 minute delay before the selected option is removed from the dropdown.

## License

MIT
