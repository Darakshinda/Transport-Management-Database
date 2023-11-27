from flask import Flask, render_template, request, redirect, url_for, make_response
from werkzeug.utils import secure_filename
import os
from os.path import join, dirname, realpath, basename
import database
import json
from datetime import datetime

os.chdir(__file__.replace(basename(__file__), ''))

app = Flask(__name__)
UPLOAD_FOLDER = join(dirname(realpath(__file__)), 'static/uploads/')
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

@app.route('/')
def index():
    room = database.source("allbuses.sql")
    types = database.source("allbustypes.sql")
    types = {type[0]: [type[1], type[2]] for type in types}

    customer = database.source("allpassengers.sql")
    customer_dict = {c[0]: c[1] + " " + c[2] for c in customer}

    employees = database.source("all_employees.sql")
    jobs = database.source("all_jobs.sql")
    jobs = {job[0]: [job[1], job[2]] for job in jobs}

    reservations = database.source("all_reservations.sql")
    return render_template("index.html", len_room=len(room),
                            room=room, room_type=types,
                            customer=customer, len_cust=len(customer),
                            jobs=jobs, employees=employees,
                            len_emp=len(employees), len_res=len(reservations),
                            cust_dict=customer_dict, res=reservations)

@app.route('/Customer', methods=['GET', 'POST'])
def customer():
    if request.method == 'POST':
        fname = request.form['fname']
        lname = request.form['lname']
        address = request.form['address']
        ph_no = request.form['ph_no']
        database.source("newpassenger.sql", fname, lname, address, ph_no, 0, output=False)
        return redirect(url_for('index'))
    return render_template("new_form.html", var="Customer")

@app.route('/Employee', methods=['GET', 'POST'])
def employee():
    if request.method == 'POST':
        fname = request.form['fname']
        lname = request.form['lname']
        address = request.form['address']
        ph_no = request.form['ph_no']
        job_id = request.form['job']
        database.source("new_employee.sql", job_id, fname, lname, address, ph_no, output=False)
        return redirect(url_for('index'))
    jobs = database.source("all_jobs.sql")
    return render_template("new_form.html", var="Employee", jobs=jobs)

@app.route('/reservation', methods=['GET', 'POST'])
# def reservation():
#     if request.method == 'POST':
#         cust_ph_no = request.form['cust']
#         cust_id = int(database.source("getpassenger.sql", cust_ph_no)[0][0])
#         room = int(request.form['room'])
#         date_format = "%Y-%m-%d"
#         d
#         days = min(stop1_real-stop1_expected,0)+min(stop2_real-stop2_expected,0)
#         days = days.days + 1
#         t_id = request.form['txn']
#         t_date = request.form['dated']
#         mode = request.form['mode']
#         amount = int(request.form['amount'])
#         status = int(request.form['status'])

#         res_id = database.source("new_reservation.sql",
#                                 cust_id, room, t_id, stop1_expected, stop1_real, stop2_expected,stop2_real,days,
#                                 output=False, lastRowId=True)
#         database.source("new_transaction.sql",
#                         t_id, None, res_id, t_date, amount, mode, 1, status, output=False)

#         return redirect(url_for('index'))

def reservation():
    if request.method == 'POST':
        passen_ph_no = request.form['cust']
        passen_id = int(database.source("getpassenger.sql", passen_ph_no)[0][0])
        room = int(request.form['room'])
        date_format = "%Y-%m-%d"
        in_date = datetime.strptime(request.form['in'], date_format)
        out_date = datetime.strptime(request.form['out'], date_format)
        days = out_date - in_date
        days = days.days + 1
        t_id = request.form['txn']
        t_date = request.form['dated']
        mode = request.form['mode']
        amount = int(request.form['amount'])
        status = int(request.form['status'])

        res_id = database.source("new_reservation.sql",
                                passen_id, room, t_id, in_date, out_date, days,
                                output=False, lastRowId=True)
        database.source("new_transaction.sql",
                        t_id, None, res_id, t_date, amount, mode, 1, status, output=False)

        return redirect(url_for('index'))
    customer = database.source("allpassengers.sql")
    rooms = database.source("allbuses.sql")
    return render_template("reservation.html", customer=customer, rooms=rooms)


def bustype(bid,btype, bcap):
    bustype=bid
    busname=btype
    buscapacity=bcap
    res_id = database.source("bustype",
                               bustype, buscapacity, busname,
                                output=False, lastRowId=True)
    return res_id


@app.route('/t')
def transaction_details():
    id = request.args["id"]
    details = database.source("get_transaction.sql", id)[0]
    details = {"date": str(details[0]),
                "amount": details[1],
                "payment": details[2],
                "status": details[3]
            }
    return json.dumps(details)

@app.route('/del/<name>')
def delete(name):
    id = request.args["id"]
    print(id)
    if name == "room":
        database.source("delbus.sql", id, output=False)
    elif name == "res":
        database.source("del_reservation.sql", id, output=False)
    elif name == "cust":
        database.source("delpassen.sql", id, output=False)
    elif name == "emp":
        database.source("del_employee.sql", id, output=False)
    
    return redirect(url_for('index'))

@app.route('/import')
def imp():
    return render_template("import.html")

@app.route('/import/<name>', methods=['POST'])
def imprt(name):
    file = request.files['file']
    if file:
        filename = secure_filename(file.filename)
        filename = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filename)
        database.import_from_csv(name, filename)
    return redirect(url_for('imp'))

@app.route('/export')
def exp():
    return render_template("export.html")

@app.route('/export/<name>')
def exprt(name):
    filename = f"./static/exports/{name}.csv"
    database.export_to_csv(name, filename)

    response = make_response(filename, 200)
    response.mimetype = "text/plain"
    return response

@app.route('/clear')
def clear():
    database.clear()
    return redirect(url_for('index'))


# import tkinter as tk
# from tkinter import messagebox

# def login():
#     entered_username = username_entry.get()
#     entered_password = password_entry.get()

#     if data.get(entered_username) == entered_password:
#         # Successful login, you can perform additional actions here
#         root.destroy()  # Close the Tkinter window
#         app.run()
#     else:
#         login_status.config(text='Invalid username or password')
#         messagebox.showerror('Login Failed', 'Invalid username or password')

# # Define your user data
# data = {'anshika': 'anshikaabc', 'darakshinda': 'darakshindaabc',  'chaitanya': 'chaitanyaabc'} 

# if __name__ == '__main__':
#     root = tk.Tk()
#     root.title('Login')

#     # Set the window size
#     window_width = 400
#     window_height = 200

#     # Get the screen width and height
#     screen_width = root.winfo_screenwidth()
#     screen_height = root.winfo_screenheight()

#     # Set the window position
#     x_position = (screen_width - window_width) // 2
#     y_position = (screen_height - window_height) // 2

#     root.geometry(f'{window_width}x{window_height}+{x_position}+{y_position}')

#     tk.Label(root, text='Username:').pack()
#     username_entry = tk.Entry(root)
#     username_entry.pack()

#     tk.Label(root, text='Password:').pack()
#     password_entry = tk.Entry(root, show='*')
#     password_entry.pack()

#     login_button = tk.Button(root, text='Login', command=login)
#     login_button.pack()

#     login_status = tk.Label(root, text='')
#     login_status.pack()

#     root.mainloop()


#################AUTHORIZATION CODE#########################
import tkinter as tk
from tkinter import messagebox
import bcrypt
import sqlite3
conn = sqlite3.connect('user_data.db')
cursor = conn.cursor()

cursor.execute('''
    CREATE TABLE IF NOT EXISTS users (
        username TEXT PRIMARY KEY,
        password TEXT NOT NULL
    )
''')
conn.commit()
def register():
    entered_username = username_entry.get()
    entered_password = password_entry.get()
    cursor.execute('SELECT * FROM users WHERE username = ?', (entered_username,))
    if cursor.fetchone():
        messagebox.showerror('Registration Failed', 'Username already exists. Choose a different username.')
        return
    hashed_password = bcrypt.hashpw(entered_password.encode('utf-8'), bcrypt.gensalt())
    cursor.execute('INSERT INTO users (username, password) VALUES (?, ?)', (entered_username, hashed_password))
    conn.commit()
    messagebox.showinfo('Registration Successful', 'User registered successfully. You can now log in.')

def login():
    entered_username = username_entry.get()
    entered_password = password_entry.get()
    cursor.execute('SELECT password FROM users WHERE username = ?', (entered_username,))
    stored_hash = cursor.fetchone()
    if stored_hash and bcrypt.checkpw(entered_password.encode('utf-8'), stored_hash[0]):
        root.destroy()
        app.run()
    else:
        login_status.config(text='Invalid username or password')
        messagebox.showerror('Login Failed', 'Invalid username or password')

def show_registration():
    login_button.config(text='Register', command=register)
    registration_label.config(text='Already have an account?')
    switch_button.config(text='Login', command=show_login)

def show_login():
    login_button.config(text='Login', command=login)
    registration_label.config(text='Don\'t have an account?')
    switch_button.config(text='Register', command=show_registration)

if __name__ == '__main__':
    root = tk.Tk()
    root.title('Login or Register')
    window_width = 400
    window_height = 200
    screen_width = root.winfo_screenwidth()
    screen_height = root.winfo_screenheight()
    x_position = (screen_width - window_width) // 2
    y_position = (screen_height - window_height) // 2
    root.geometry(f'{window_width}x{window_height}+{x_position}+{y_position}')
    tk.Label(root, text='Username:').pack()
    username_entry = tk.Entry(root)
    username_entry.pack()
    tk.Label(root, text='Password:').pack()
    password_entry = tk.Entry(root, show='*')
    password_entry.pack()
    login_button = tk.Button(root, text='Login', command=login)
    login_button.pack()
    registration_label = tk.Label(root, text='Don\'t have an account?')
    registration_label.pack()
    switch_button = tk.Button(root, text='Register', command=show_registration)
    switch_button.pack()
    login_status = tk.Label(root, text='')
    login_status.pack()

    root.mainloop()
