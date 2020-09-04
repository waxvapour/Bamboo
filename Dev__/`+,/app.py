from flask import Flask, render_template, flash, redirect, url_for, session, request, logging
from passlib.hash import sha256_crypt
import nmap
app = Flask(__name__)

def nmapScann(addr):
    begin = 75
    end = 80
    target = addr
    scanner = nmap.PortScanner() 
    ress = []
    hostname = "NOT RESOLVED"
    for i in range(begin,end+1): 
        res = scanner.scan(target,str(i)) 
        hostname = scanner[target].hostname()
        res = res['scan'][target]['tcp'][i]['state']
        if res =='open':
            ress.append(i)
        poss = {'ress': ress, 'hostname': hostname}
    return poss
@app.route('/')
def root():
    return render_template('base.html')

@app.route('/actor', methods=['POST'])
def actor():
    data = request.form['Target']
    nmapScanResult = nmapScann(data)
    return render_template('actor.html', data=data, nmapScanResult=nmapScanResult)

if __name__ == '__main__':
    app.run(debug=True)


    