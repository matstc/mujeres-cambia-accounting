We want to solve the challenge submitted by [Mujeres Cambia](http://www.mujerescambia.com).

Here is the [video for the challenge](https://vimeo.com/65755818).

# Use Cases
We want to use SMS texting to do the following:

### 1—Send new rows for accounting to spreadsheet Registro
- a single line at a time
- verify formats
- send a confirmation with success message or error stating mishaps

### 2—Update inventory after something was sold
- multiple rows at a time
- using the inventory id to locate the product, update the sold date and the price it was sold at
- do we send confirmation message?

### 3—Get state of the accounts
- respond to an SMS code (e.g. BALANCE?) with the amounts in the various accounts (banco, efectivo, paypal, ...)
- this functionality could be implemented by just sending back the value of a cell. The excel function of that cell would compute the desired response.
- this functionality could be extended to allow for other SMS codes to be added without changes to the codebase

### 4—Get next available inventory id
- useful when creating new products
- return the next available id which is the highest number in column A of the inventory + 1

### 5—Send inventory code and get inventory line
- a single line at a time
- just return the whole line associated with inventory id received

# The Spreadsheets
- [Registro](https://docs.google.com/spreadsheet/ccc?key=0An3bayXoCNo7dFp4UkJMYS0wcGlJbmR5VWxYUGtibXc#gid=0)
- [Inventario](https://docs.google.com/spreadsheet/ccc?key=0An3bayXoCNo7dFZjZERBajg1RkExOXQ5eXdIU1ZQYUE#gid=0u)

# Research
The following technologies could be helpful:

- [Twilio](https://www.twilio.com)
- [ClockWorkSMS](http://www.clockworksms.com/doc/easy-stuff/code-wrappers/ruby/)
- [BulkSMS](https://bulksms.vsms.net/)

A similar project was implemented using Twilio. [Here is the github for it](https://github.com/matstc/rhok-accountability).
