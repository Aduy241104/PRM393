import '../models/owner.dart';
import '../models/pet.dart';
import '../models/vaccine.dart';

class VaccineService {
	VaccineService._();

	static final VaccineService instance = VaccineService._();

	final List<Owner> _owners = [
		Owner(
			id: 1,
			userId: 1,
			name: 'Nguyen Van A',
			phone: '0123456789',
			email: 'a@gmail.com',
			address: 'Can Tho',
		),
		Owner(
			id: 2,
			userId: 2,
			name: 'Tran Thi B',
			phone: '0987654321',
			email: 'b@gmail.com',
			address: 'Ho Chi Minh',
		),
	];

	final List<Pet> _pets = [
		Pet(
			id: 1,
			ownerId: 1,
			name: 'Milo',
			type: 'Dog',
			breed: 'Poodle',
			age: 2,
			image: '',
		),
		Pet(
			id: 2,
			ownerId: 1,
			name: 'Luna',
			type: 'Cat',
			breed: 'British Shorthair',
			age: 1,
			image: '',
		),
		Pet(
			id: 3,
			ownerId: 2,
			name: 'Max',
			type: 'Dog',
			breed: 'Corgi',
			age: 3,
			image: '',
		),
	];

	final List<Vaccine> _vaccines = [
		Vaccine(
			id: 1,
			petId: 1,
			vaccineName: 'Dai',
			date: '2026-01-10',
			nextDueDate: '2027-01-10',
		),
		Vaccine(
			id: 2,
			petId: 1,
			vaccineName: '7 in 1',
			date: '2026-02-12',
			nextDueDate: '2027-02-12',
		),
		Vaccine(
			id: 3,
			petId: 3,
			vaccineName: 'Parvo',
			date: '2026-03-01',
			nextDueDate: '2027-03-01',
		),
	];

	int _nextVaccineId = 4;

	Future<List<Owner>> getOwners() async {
		return List<Owner>.from(_owners);
	}

	Future<Owner?> getOwnerByUserId(int userId) async {
		for (final owner in _owners) {
			if (owner.userId == userId) {
				return owner;
			}
		}
		return null;
	}

	Future<List<Pet>> getPetsByOwner(int ownerId) async {
		return _pets.where((pet) => pet.ownerId == ownerId).toList();
	}

	Future<List<Pet>> getAllPets() async {
		return List<Pet>.from(_pets);
	}

	Future<List<Vaccine>> getVaccinesByPet(int petId) async {
		return _vaccines.where((vaccine) => vaccine.petId == petId).toList();
	}

	Future<List<Vaccine>> getAllVaccines() async {
		return List<Vaccine>.from(_vaccines);
	}

	Future<List<Vaccine>> getVaccinesByPetIds(List<int> petIds) async {
		if (petIds.isEmpty) return [];
		return _vaccines.where((vaccine) => petIds.contains(vaccine.petId)).toList();
	}

	Future<void> addVaccine({
		required int petId,
		required String vaccineName,
		required String date,
		required String nextDueDate,
	}) async {
		_vaccines.add(
			Vaccine(
				id: _nextVaccineId++,
				petId: petId,
				vaccineName: vaccineName,
				date: date,
				nextDueDate: nextDueDate,
			),
		);
	}

	Future<void> updateVaccine({
		required int vaccineId,
		required int petId,
		required String vaccineName,
		required String date,
		required String nextDueDate,
	}) async {
		final index = _vaccines.indexWhere((vaccine) => vaccine.id == vaccineId);
		if (index == -1) return;

		_vaccines[index] = Vaccine(
			id: vaccineId,
			petId: petId,
			vaccineName: vaccineName,
			date: date,
			nextDueDate: nextDueDate,
		);
	}

	Future<void> deleteVaccine(int vaccineId) async {
		_vaccines.removeWhere((vaccine) => vaccine.id == vaccineId);
	}
}
