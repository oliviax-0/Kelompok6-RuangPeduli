# RuangPeduli

RuangPeduli is a mobile application designed to bridge the gap between orphanages and the community while helping orphanage administrators manage daily operations more efficiently. The platform provides separate user experiences for public users and orphanage administrators, enabling better community engagement, donation management, inventory tracking, and financial record management.

## Team

Kelompok 6

## Tech Stack

### Frontend

* Flutter

### Backend

* Django 

### Tools

* Figma

## Project Structure

Kelompok6-RuangPeduli
│
├── ruangpeduli/       # Backend (Django)
└── ruangpeduliapp/    # Frontend (Flutter)
```

## Figma Prototype

https://www.figma.com/proto/X0149JYFQxoLEfn96F0eN4/SDC-HORE?node-id=308-4850&p=f&t=D6KaJx0E95BgCZI7-1&scaling=scale-down&content-scaling=fixed&page-id=17%3A9&starting-point-node-id=699%3A7523

## Features

### Public Users

* View orphanage news and updates
* Search nearby orphanages
* View donation history
* Manage personal profile
* AI chatbot assistance

### Orphanage Administrators

* Inventory management
* Financial records management
* Resident and employee management
* News creation and publishing
* AI-powered operational assistance
* Low-stock notifications and monitoring

## Installation Guide

### 1. Run Backend

```bash
cd ruangpeduli
python manage.py runserver 0.0.0.0:8000
```

### 2. Update API URL

Replace the localhost URL in the Flutter application with your local machine's IP address.

Example:

```text
http://192.168.x.x:8000
```

### 3. Run Frontend

```bash
cd ruangpeduliapp
flutter pub get
flutter run
```

## Demo Flow

1. Register an account
2. Verify email
3. Login
4. Access features based on user role
5. Explore donation, inventory, financial, and AI chatbot functionalities

## Project Status

This project was developed as an academic project and successfully delivered a functional prototype. Core features have been implemented and tested; however, several areas, particularly within the public user module, have been identified for future improvements and refinement.

## Contributors

Kelompok 6 – DBT 24&25
Universitas Prasetiya Mulya
